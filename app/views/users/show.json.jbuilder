json.status @status
json.result do
  json.extract! @user, :id, :email, :token
end
