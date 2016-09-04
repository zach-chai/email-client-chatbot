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

  def parse_rules(msg)
    msg = Textoken(msg.downcase).tokens
    if msg.include? 'help'
      'help'
    elsif include_any? msg, FETCH_KEYS
      'fetch email'
    else
      msg
    end
  end

  def include_any?(msg, keys)
    keys.each do |key|
      if msg.include? key
        return true
      end
    end
    false
  end
end
