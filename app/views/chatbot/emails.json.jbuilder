json.emails do
  json.array!(@emails) do |email|
    json.partial! 'emails/email', email: email
  end
end

if @msg
  json.msg @msg
end
