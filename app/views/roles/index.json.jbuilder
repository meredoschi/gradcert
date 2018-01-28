json.array!(@roles) do |role|
  json.extract! role, :id, :name, :management, :teaching, :clerical
  json.url role_url(role, format: :json)
end
