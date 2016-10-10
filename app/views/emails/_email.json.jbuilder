json.extract! email, :id, :subject, :sender, :body, :created_at, :updated_at
json.url email_url(email, format: :json)
