json.array!(@councils) do |council|
  json.extract! council, :id, :name, :address_id, :phone_id, :webinfo_id, :state_id
  json.url council_url(council, format: :json)
end
