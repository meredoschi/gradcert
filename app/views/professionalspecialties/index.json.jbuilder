json.array!(@professionalspecialties) do |professionalspecialty|
  json.extract! professionalspecialty, :id, :name, :fundapcode, :professionalarea_id
  json.url professionalspecialty_url(professionalspecialty, format: :json)
end
