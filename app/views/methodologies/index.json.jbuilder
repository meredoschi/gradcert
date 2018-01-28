json.array!(@methodologies) do |methodology|
  json.extract! methodology, :id, :name
  json.url methodology_url(methodology, format: :json)
end
