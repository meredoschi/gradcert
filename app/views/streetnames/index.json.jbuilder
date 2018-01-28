json.array!(@streetnames) do |streetname|
  json.extract! streetname, :id, :nome
  json.url streetname_url(streetname, format: :json)
end
