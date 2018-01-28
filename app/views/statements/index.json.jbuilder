json.array!(@statements) do |statement|
  json.extract! statement, :id, :registration_id, :payroll_id, :grossamount_cents, :incometax_cents, :socialsecurity_cents, :childsupport_cents, :netamount_cents
  json.url statement_url(statement, format: :json)
end
