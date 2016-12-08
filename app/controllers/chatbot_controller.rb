class ChatbotController < ApplicationController

  FETCH_TOKENS = ['fetch', 'get', 'find', 'open', 'show', 'view', 'read']
  DELETE_TOKENS = ['delete', 'destroy', 'remove']
  EMAIL_TYPES = ['today', 'todays', 'yesterday', 'yesterdays', 'all'] # implemented unread

  MSG_SET = [
    [['what'], ['emails'], EMAIL_TYPES],
    [FETCH_TOKENS, ['emails'], ['have']],
    [FETCH_TOKENS, ['emails'], EMAIL_TYPES],
    [FETCH_TOKENS, EMAIL_TYPES, ['emails']],
    [FETCH_TOKENS, ['emails']],
    [FETCH_TOKENS, ['my'], ['emails']],
    [FETCH_TOKENS, ['emails'], ['from'], EMAIL_TYPES],
    [FETCH_TOKENS, ['emails'], ['from']], # expecting email address
    [['search'], ['for'], ['emails'], ['from']], # expecting email address
    # [['search'], ['for']], # expecting string to search subject and body
    [DELETE_TOKENS, ['emails']],
    [DELETE_TOKENS, EMAIL_TYPES, ['emails']],
    [DELETE_TOKENS, ['emails'], ['from']] # expecting email address
  ]
  #TODO detect if email address and fetch those emails

  # {message: "message to chatbot"}

  def message
    msg = params[:message] || 'Hello user'
    msg = Textoken(msg.downcase).tokens
    msg.delete_if { |m| m == "'" || m == "s" }

    msg_set, type = get_msg_set(msg, true)

    if msg_set
      if msg_set < 9 # fetch emails
        if (type & ["today", "todays"]).first
          @emails = Email.where("created_at > (?)", Time.now.beginning_of_day)
          @msg = "You received #{@emails.count} emails today"
        elsif (type & ["yesterday", "yesterdays"]).first
          @emails = Email.where("created_at > (?) and created_at < (?)", (Time.now - 1.days).beginning_of_day, (Time.now - 1.days).end_of_day)
          @msg = "You received #{@emails.count} emails yesterday"
        elsif (type & ["from"]).first
          @emails = Email.where(sender: type.last)
          @msg = "You received #{@emails.count} emails from #{type.last}"
        else
          @emails = Email.all
          @msg = "You have #{@emails.count} emails"
        end
      elsif msg_set < 12 # delete emails
        if (type & ["today"]).first
          Email.where("created_at > (?)", Time.now.beginning_of_day).destroy_all
          @emails = Email.all
          @msg = "Today's emails were deleted"
        elsif (type & ["yesterday"]).first
          Email.where("created_at > (?) and created_at < (?)", (Time.now - 1.days).beginning_of_day, (Time.now - 1.days).end_of_day).destroy_all
          @emails = Email.all
          @msg = "Yesterday's emails were deleted"
        elsif (type & ["all"]).first
          Email.destroy_all
          @emails = Email.all
          @msg = "All emails deleted"
        elsif (type & ["from"]).first
          Email.where(sender: type.last).destroy_all
          @emails = Email.all
          @msg = "All emails from #{type.last} were deleted"
        else
          @emails = Email.all
          @msg = "Suggestion \"delete all emails\""
          @suggestion = "delete all emails"
        end
      else
        @msg = "I don't understand"
        return
      end
    else
      msg_set, type = get_msg_set(msg, false)

      @msg = if msg_set
        @suggestion = type.join ' '
        "Suggestion \"#{type.join ' '}\""
      else
        "I don't understand"
      end
    end
  end

  private

  def get_msg_set(msg, strict = false)
    counter = 0
    MSG_SET.each do |fetch_set|
      if matches = ordered_tokens_exist?(msg, fetch_set, strict)
        return counter, matches
      else
        counter += 1
      end
    end
    false
  end

  def ordered_tokens_exist?(msg, tokens, strict = false)
    matches = []
    skip = 0
    if !strict
      temp_tokens = tokens.clone
      msg.each do |msg_token|
        if temp_tokens.first.include? msg_token
          temp_tokens.shift
          matches << msg_token
        end
        if temp_tokens.empty? && skip == 0
          return matches
        end
      end
      false
    else
      temp_tokens = tokens.clone
      msg.each do |msg_token|
        if skip > 0
          skip -= 1
          next
        end
        if temp_tokens.first.include? msg_token
          temp_tokens.shift
          matches << msg_token
          if msg_token == 'from'
            if msg.include? '@'
              email, skip = email_from_msg msg
              matches << email
            end
          end
        else
          return false
        end
      end
      if temp_tokens.empty? && skip == 0
        return matches
      end
      false
    end
  rescue
    false
  end

  def email_from_msg(msg)
    beg_index = msg.rindex('from') + 1
    end_index = msg.rindex('.') + 1
    skip = end_index - beg_index + 1
    return msg[beg_index..end_index].join, skip
  end

end
