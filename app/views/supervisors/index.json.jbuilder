json.array!(@supervisors) do |supervisor|
  json.extract! supervisor, :id, :contact_id, :work_start, :program_start, :institution_id, :profession_id, :highest_degree_held, :graduation_date, :lead, :alternate, :total_working_hours_week, :teaching_hours_week, :contract_type
  json.url supervisor_url(supervisor, format: :json)
end
