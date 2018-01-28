json.array!(@programsituations) do |programsituation|
  json.extract! programsituation, :id, :assesment_id, :duration_change_requested, :expected_duration, :expected_first_year_grants, :expected_second_year_grants, :summary_of_program_goals, :program_nature, :first_year_instructional_hours_theory, :first_year_instructional_hours_practice, :second_year_instructional_hours_theory, :second_year_instructional_hours_practice
  json.url programsituation_url(programsituation, format: :json)
end
