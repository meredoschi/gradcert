json.array!(@characteristics) do |characteristic|
  json.extract! characteristic, :id, :institution_id, :mission, :corevalues, :userprofile, :stateregion_id, :relationwithpublichealthcare, :publicfundinglevel, :highlightareas
  json.url characteristic_url(characteristic, format: :json)
end
