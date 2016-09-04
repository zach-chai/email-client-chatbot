Rails.application.routes.draw do
  get "/chatbot", to: "chatbot#message", defaults: {format: 'json'}
  get "/testbot", to: "chatbot#test"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
