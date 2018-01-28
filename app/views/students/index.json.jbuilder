json.array!(@students) do |student|
  json.extract! student, :id, :contact_id, :profession_id, :council_id
  json.url student_url(student, format: :json)
end
