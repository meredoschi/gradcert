# This will guess the User class
FactoryBot.define do
  factory :feedback do
#    Feedback(id: integer, registration_id: integer, processingdate: date, approved: boolean, created_at: datetime, updated_at: datetime, payroll_id: integer, processed: boolean, bankpayment_id: integer, comment: string)
#    reg_id=Registration.active.contextual_today.last
#    payment_id=Bankpayment.joins(:payroll).merge(Payroll.special).last
#    registration_id reg_id
#    registration_id 1
    association :registration, factory: :registration
    association :bankpayment, factory: :bankpayment
  end
end
