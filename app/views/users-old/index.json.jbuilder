json.array!(@users) do |user|
  json.extract! user, :name, :birthdate, :sex, :email
  json.url user_url(user, format: :json)
end
