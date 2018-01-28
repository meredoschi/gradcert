json.array!(@schoolnames) do |schoolname|
  json.extract! schoolname, :id, :name, :previousname, :active
  json.url schoolname_url(schoolname, format: :json)
end
