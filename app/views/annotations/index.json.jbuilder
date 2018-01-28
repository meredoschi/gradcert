json.array!(@annotations) do |annotation|
  json.extract! annotation, :id, :registration_id, :payroll_id, :absences, :discount, :skip, :comment
  json.url annotation_url(annotation, format: :json)
end
