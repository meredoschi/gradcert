json.array!(@assessments) do |assessment|
  json.extract! assessment, :id, :contact_id, :program_id, :profession_id, :duration_change_requested, :recommended_duration, :recommended_first_year_grants, :recommended_second_year_grants, :summary_of_program_goals, :program_nature_vocation, :first_year_theory_hours, :first_year_practice_hours, :second_year_theory_hours, :second_year_practice_hours
  json.url assessment_url(assessment, format: :json)
end
