if @emails
  json.emails do
    json.array!(@emails) do |email|
      json.partial! 'emails/email', email: email
    end
  end
end

if @msg
  json.msg @msg
  json.suggestion @suggestion if @suggestion
end
