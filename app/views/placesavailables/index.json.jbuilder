json.array!(@placesavailables) do |placesavailable|
  json.extract! placesavailable, :id, :institution_id, :schoolterm_id, :requested, :accredited, :authorized
  json.url placesavailable_url(placesavailable, format: :json)
end
