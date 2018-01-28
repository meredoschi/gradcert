json.array!(@feedbacks) do |feedback|
  json.extract! feedback, :id, :registration_id, :payroll_id, :returndate, :returned, :processed
  json.url feedback_url(feedback, format: :json)
end
