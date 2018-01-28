json.array!(@coursenames) do |coursename|
  json.extract! coursename, :id, :name, :active
  json.url coursename_url(coursename, format: :json)
end
