json.array!(@programs) do |program|
  json.extract! program, :id, :institution_id, :programname_id, :programnum, :instprogramnum, :duration, :varchar
  json.url program_url(program, format: :json)
end
