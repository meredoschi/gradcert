json.array!(@makeupschedules) do |makeupschedule|
  json.extract! makeupschedule, :id, :start, :finish, :registration_id
  json.url makeupschedule_url(makeupschedule, format: :json)
end
