json.array!(@researchcenters) do |researchcenter|
  json.extract! researchcenter, :id, :institution_id, :rooms, :labs, :intlprojectsdone, :ongoingintlprojects, :domesticprojectsdone, :ongoingdomesticprojects
  json.url researchcenter_url(researchcenter, format: :json)
end
