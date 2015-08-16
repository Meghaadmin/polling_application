json.array!(@users) do |user|
  json.extract! user, :id, :name, :password, :user_type, :email_id, :is_approved
  json.url user_url(user, format: :json)
end
