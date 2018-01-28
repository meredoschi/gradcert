json.array!(@institutiontypes) do |institutiontype|
  json.extract! institutiontype, :id, :name
  json.url institutiontype_url(institutiontype, format: :json)
end
