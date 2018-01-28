json.array!(@events) do |event|
  json.extract! event, :id, :start, :finish, :leavetype_id, :absence
  json.url event_url(event, format: :json)
end
