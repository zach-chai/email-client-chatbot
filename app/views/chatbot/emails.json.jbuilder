json.array(@emails) do |email|
  json.extract! email, :subject, :sender, :body
end
