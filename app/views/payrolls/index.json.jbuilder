json.array!(@payrolls) do |payroll|
  json.extract! payroll, :id, :paymentdate, :comment
  json.url payroll_url(payroll, format: :json)
end
