json.array!(@institutions) do |institution|
  json.extract! institution, :id, :name, :streetname_id, :address, :addresscomplement, :neighborhood, :municipality_id, :postalcode, :mainphone, :url, :email, :institutiontype_id, :pap, :medicalresidency, :provisional
  json.url institution_url(institution, format: :json)
end
