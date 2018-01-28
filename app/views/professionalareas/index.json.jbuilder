json.array!(@professionalareas) do |professionalarea|
  json.extract! professionalarea, :id, :name, :previouscode
  json.url professionalarea_url(professionalarea, format: :json)
end
