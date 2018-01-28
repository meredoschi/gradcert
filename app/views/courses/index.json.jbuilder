json.array!(@courses) do |course|
  json.extract! course, :id, :coursename_id, :profession_id, :practical, :core, :professionalrequirement, :contact_id, :methodology_id, :address_id, :workload, :syllabus
  json.url course_url(course, format: :json)
end
