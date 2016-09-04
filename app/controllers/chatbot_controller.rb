class ChatbotController < ApplicationController

  # {message: "message to chatbot"}

  # POST /chatbots
  def message
    msg = params[:message] || 'Hello user'
    msg = msg.gsub(/[^0-9a-z ]/i, '')

    @res = msg
  end

  def test

  end
end
