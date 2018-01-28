json.array!(@schools) do |school|
  json.extract! school, :id, :name, :abbreviation, :ministrycode, :academiccategory_id, :public
  json.url school_url(school, format: :json)
end
