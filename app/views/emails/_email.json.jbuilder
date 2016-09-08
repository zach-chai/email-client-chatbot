json.extract! email, :id, :name, :body, :created_at, :updated_at
json.url email_url(email, format: :json)