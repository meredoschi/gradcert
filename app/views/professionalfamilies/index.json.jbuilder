json.array!(@professionalfamilies) do |professionalfamily|
  json.extract! professionalfamily, :id, :name, :subgroup_id, :familycode, :pap, :medres
  json.url professionalfamily_url(professionalfamily, format: :json)
end
