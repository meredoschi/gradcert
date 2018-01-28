json.array!(@assignments) do |assignment|
  json.extract! assignment, :id, :program_id, :supervisor_id, :start_date, :main
  json.url assignment_url(assignment, format: :json)
end
