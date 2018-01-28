json.array!(@countries) do |country|
  json.extract! country, :id, :nome, :a2, :a3, :numero
  json.url country_url(country, format: :json)
end
