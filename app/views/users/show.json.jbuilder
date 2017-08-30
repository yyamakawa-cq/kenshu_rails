# あとで削除
# json.partial! "users/user", user: @user
json.status @status
json.result do
  json.extract! @user, :id, :email, :token
end
