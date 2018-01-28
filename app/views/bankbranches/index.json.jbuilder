json.array!(@bankbranches) do |bankbranch|
  json.extract! bankbranch, :id, :num, :name, :formername, :municipality_id
  json.url bankbranch_url(bankbranch, format: :json)
end
