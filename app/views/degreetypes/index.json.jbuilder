json.array!(@degreetypes) do |degreetype|
  json.extract! degreetype, :id, :name
  json.url degreetype_url(degreetype, format: :json)
end
