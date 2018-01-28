json.array!(@bankpayments) do |bankpayment|
  json.extract! bankpayment, :id, :payroll_id, :comment, :sent
  json.url bankpayment_url(bankpayment, format: :json)
end
