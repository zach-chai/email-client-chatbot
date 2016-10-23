class ChatbotController < ApplicationController

  FETCH_TOKENS = ['fetch', 'get', 'find', 'open', 'show', 'view', 'read']
  DELETE_TOKENS = ['delete', 'destroy', 'remove']
  EMAIL_TYPES = ['today', 'todays', 'today\'s' 'yesterday', 'yesterdays', 'yesterday\'s', 'all'] # implemented unread

  MSG_SET = [
    [['what'], ['emails'], EMAIL_TYPES],
    [FETCH_TOKENS, ['emails'], ['have']],
    [FETCH_TOKENS, ['emails'], EMAIL_TYPES],
    [FETCH_TOKENS, EMAIL_TYPES, ['emails']],
    [FETCH_TOKENS, ['emails']],
    [DELETE_TOKENS, ['email']],
    [DELETE_TOKENS, EMAIL_TYPES, ['emails']]
  ]
  #TODO detect if email address and fetch those emails

  # {message: "message to chatbot"}

  # POST /chatbots
  def message
    msg = params[:message] || 'Hello user'
    msg = Textoken(msg.downcase).tokens

    # @res = parse_rules msg
    @res = parse_sets msg
    # @res = "#{@res}: #{ordered_tokens_heuristic(msg, [FETCH_TOKENS, EMAIL_TYPES])}"

    @res
  end

  def emails
    msg = params[:message] || 'Hello user'
    msg = Textoken(msg.downcase).tokens

    msg_set, type = get_msg_set(msg)

    if msg_set == false
      @msg = "I don't understand"
      return
    elsif msg_set < 5 # fetch emails
      if (type & ["today", "todays", "today's"]).first
        @emails = Email.where("created_at > (?)", Time.now.beginning_of_day)
        @msg = "You received #{@emails.count} emails today"
      elsif (type & ["yesterday", "yesterdays", "yesterday's"]).first
        @emails = Email.where("created_at > (?) and created_at < (?)", (Time.now - 1.days).beginning_of_day, (Time.now - 1.days).end_of_day)
        @msg = "You received #{@emails.count} emails yesterday"
      else
        @emails = Email.all
        @msg = "You have #{@emails.count} emails"
      end
    elsif msg_set < 7 # delete emails
      if (type & ["today", "todays", "today's"]).first
        Email.where("created_at > (?)", Time.now.beginning_of_day).destroy_all
        @emails = Email.all
        @msg = "Today's emails were deleted"
      elsif (type & ["yesterday", "yesterdays", "yesterday's"]).first
        Email.where("created_at > (?) and created_at < (?)", (Time.now - 1.days).beginning_of_day, (Time.now - 1.days).end_of_day).destroy_all
        @emails = Email.all
        @msg = "Yesterday's emails were deleted"
      else
        Email.destroy_all
        @emails = Email.all
        @msg = "All emails deleted"
      end
    else
      @msg = "I don't understand"
      return
    end
  end

  def test

  end

  private

  def get_msg_set(msg)
    counter = 0
    MSG_SET.each do |fetch_set|
      if matches = ordered_tokens_exist?(msg, fetch_set, true)
        return counter, matches
      else
        counter += 1
      end
    end
    false
  end

  def parse_rules(msg)
    if msg.include? 'help'
      'help'
    elsif ordered_tokens_exist? msg, [FETCH_TOKENS, EMAIL_TYPES]
      "fetch emails ordered_tokens"
    elsif include_any? msg, FETCH_TOKENS
      if email_type = include_any?(msg, EMAIL_TYPES)
        "fetch emails #{email_type}"
      else
        "fetch emails default"
      end
    else
      msg
    end
  end

  def parse_sets(msg)
    counter = 0
    MSG_SET.each do |fetch_set|
      if matches = ordered_tokens_exist?(msg, fetch_set, true)
        return "fetch set #{counter} with matches #{matches}"
      else
        counter += 1
      end
    end
    msg
  end

  def include_any?(msg, tokens)
    tokens.each do |token|
      if msg.include? token
        return token
      end
    end
    false
  end

  def ordered_tokens_exist?(msg, tokens, strict = false)
    matches = []
    if strict
      temp_tokens = tokens.clone
      msg.each do |msg_token|
        if temp_tokens.first.include? msg_token
          temp_tokens.shift
          matches << msg_token
        end
        if temp_tokens.empty?
          return matches
        end
      end
      false
    else
      tokens.each do |token_array|
        if token_array.include? msg.first
          matches << msg.shift
        end
      end
      if matches.empty?
        false
      else
        matches
      end
    end
  end

  def ordered_tokens_heuristic(msg, tokens, opts = {})
    tokens_length = tokens.length
    msg.each do |msg_token|
      if tokens.first.include? msg_token
        tokens = tokens.delete(0)
      end
      if tokens.nil?
        tokens = []
        break
      end
    end
    (tokens_length - tokens.length).to_f / tokens_length.to_f
  end
end
