json.array!(@municipalities) do |municipality|
  json.extract! municipality, :id, :name, :mesoregion_id
  json.url municipality_url(municipality, format: :json)
end
