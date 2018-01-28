json.array!(@leavetypes) do |leavetype|
  json.extract! leavetype, :id, :name, :paid, :comment
  json.url leavetype_url(leavetype, format: :json)
end
