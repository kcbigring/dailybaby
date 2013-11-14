json.array!(@recipients) do |recipient|
  json.extract! recipient, :user_id, :delivery_id, :create, :destroy
  json.url recipient_url(recipient, format: :json)
end
