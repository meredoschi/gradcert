json.array!(@academiccategories) do |academiccategory|
  json.extract! academiccategory, :id, :name
  json.url academiccategory_url(academiccategory, format: :json)
end
