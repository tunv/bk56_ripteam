json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :password, :dob, :date, :repuation
  json.url user_url(user, format: :json)
end
