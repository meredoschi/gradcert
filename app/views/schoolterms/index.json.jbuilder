json.array!(@schoolterms) do |schoolterm|
  json.extract! schoolterm, :id, :start, :finish, :duration, :active, :pap, :medres
  json.url schoolterm_url(schoolterm, format: :json)
end
