json.array!(@colleges) do |college|
  json.extract! college, :id, :institution_id, :area, :classrooms, :otherrooms, :sportscourts, :foodplaces, :libraries, :gradcertificatecourses, :previousyeargradcertcompletions
  json.url college_url(college, format: :json)
end
