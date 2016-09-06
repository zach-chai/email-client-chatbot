class ChatbotController < ApplicationController

  # {message: "message to chatbot"}

  # POST /chatbots
  def message
    msg = params[:message] || 'Hello user'
    msg = Textoken(msg.downcase).tokens

    @res = parse_rules msg
    @res = "#{@res}: #{ordered_tokens_heuristic(msg, [FETCH_TOKENS, EMAIL_TYPES])}"

    @res
  end

  def test

  end

  private

  FETCH_TOKENS = ['fetch', 'get', 'find', 'open', 'show', 'view', 'what', 'tell', 'give', 'read']
  EMAIL_TYPES = ['unread', 'recent', 'today', 'yesterday']
  #TODO detect if email address and fetch those emails

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

  def include_any?(msg, tokens)
    tokens.each do |token|
      if msg.include? token
        return token
      end
    end
    false
  end

  def ordered_tokens_exist?(msg, tokens, strict = false)
    msg.each do |msg_token|
      if tokens.first.include? msg_token
        tokens.shift
      end
    end
    if tokens.empty?
      true
    else
      false
    end
  end

  def ordered_tokens_heuristic(msg, tokens, opts = {})
    tokens_length = tokens.length
    msg.each do |msg_token|
      if tokens.first.include? msg_token
        tokens.shift
      end
    end
    (tokens_length - tokens.length).to_f / tokens_length.to_f
  end
end
