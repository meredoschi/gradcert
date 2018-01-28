json.array!(@taxations) do |taxation|
  json.extract! taxation, :id, :socialsecurity, :bracket_id
  json.url taxation_url(taxation, format: :json)
end
