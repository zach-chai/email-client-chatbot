class ChatbotController < ApplicationController

  # {message: "message to chatbot"}

  # POST /chatbots
  def message
    @res = "Hello user"
  end
end
