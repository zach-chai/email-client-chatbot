class ChatbotController < ApplicationController

  # {message: "message to chatbot"}

  # POST /chatbots
  def message
    msg = params[:message] || 'Hello user'
    # msg = msg.gsub(/[^0-9a-z ]/i, '')
    msg = parse_rules msg

    @res = msg
  end

  def test

  end

  private

  FETCH_KEYS = ['fetch', 'get', 'find', 'open', 'show', 'view']
  EMAIL_TYPES = ['unread', 'recent', 'today', 'yesterday']
  #TODO detect if email address and fetch those emails

  def parse_rules(msg)
    msg = Textoken(msg.downcase).tokens
    if msg.include? 'help'
      'help'
    elsif include_any? msg, FETCH_KEYS
      if email_type = include_any?(msg, EMAIL_TYPES)
        "fetch emails #{email_type}"
      else
        "fetch emails default"
      end
    else
      msg
    end
  end

  def include_any?(msg, keys)
    keys.each do |key|
      if msg.include? key
        return key
      end
    end
    false
  end
end
