# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :bankpayment do
    # Other attributes
    # prepared: boolean
    # resend: boolean (deprecated) - where payroll is special
    # statements: boolean

    comment { 'Test' }
    sequence(:sequential, &:to_s)
    totalamount_cents { 300_000_000 }

    # http://blog.pardner.com/2012/10/how-to-specify-traits-for-model-associations-in-FactoryBot/
    association :payroll, factory: %i[payroll personal_taxation]

    trait :done do
      done { true }
    end

    trait :special do
      association :payroll, factory: %i[payroll personal_taxation special]

      #    this wasn't working properly when creating multiple
      #    payroll { build(:payroll, :personal_taxation, :special) }
    end
  end
end
