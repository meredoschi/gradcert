json.array!(@schooltypes) do |schooltype|
  json.extract! schooltype, :id, :name
  json.url schooltype_url(schooltype, format: :json)
end
