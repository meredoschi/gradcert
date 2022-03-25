# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :annotation do
    # registration_id: integer, payroll_id: integer, absences: integer,
    # discount_cents: integer, skip: boolean, comment: string,
    # supplement_cents: integer, confirmed: boolean, automatic: boolean
    discount_cents { 0 }
    supplement_cents { 0 }
    confirmed { true }
  end
end
