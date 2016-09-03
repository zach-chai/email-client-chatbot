Rails.application.routes.draw do
  get "/chatbot", to: "chatbot#message", defaults: {format: 'json'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
