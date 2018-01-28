json.array!(@programnames) do |programname|
  json.extract! programname, :id, :name
  json.url programname_url(programname, format: :json)
end
