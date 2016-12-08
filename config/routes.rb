Rails.application.routes.draw do
  resources :emails
  post "/chatbot/message", to: "chatbot#message", defaults: {format: 'json'}
  get "/demo", to: "emails#demo"
end
