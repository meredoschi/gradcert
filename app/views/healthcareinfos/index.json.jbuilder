json.array!(@healthcareinfos) do |healthcareinfo|
  json.extract! healthcareinfo, :id, :institution_id, :totalbeds, :icubeds, :ambulatoryrooms, :labs, :emergencyroombeds, :otherequipment
  json.url healthcareinfo_url(healthcareinfo, format: :json)
end
