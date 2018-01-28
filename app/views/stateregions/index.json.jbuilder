json.array!(@stateregions) do |stateregion|
  json.extract! stateregion, :id, :name, :brstate_id
  json.url stateregion_url(stateregion, format: :json)
end
