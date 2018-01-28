json.array!(@contacts) do |contact|
  json.extract! contact, :id, :user_id, :salutation, :name, :email, :phone, :phone2, :mobile, :role_id, :streetname_id, :address, :addresscomplement, :neighborhood, :municipality_id, :postalcode, :termstart, :termfinish
  json.url contact_url(contact, format: :json)
end
