json.array!(@regionaloffices) do |regionaloffice|
  json.extract! regionaloffice, :id, :name, :references, :references, :references
  json.url regionaloffice_url(regionaloffice, format: :json)
end
