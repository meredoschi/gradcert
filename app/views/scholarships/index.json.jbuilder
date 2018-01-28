json.array!(@scholarships) do |scholarship|
  json.extract! scholarship, :id, :amount, :start, :finish
  json.url scholarship_url(scholarship, format: :json)
end
