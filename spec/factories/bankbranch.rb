# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :bankbranch do
    before(:create) do |bankbranch|
      bankbranch.verificationdigit = Brazilianbanking.branch_verification_digit(bankbranch.code)
      bankbranch.formername = bankbranch.name.upcase
    end

    sequence(:name) { |n| (Faker::Address.street_name + ' ' + (rand(100) + n).to_s).to_s }
    sequence(:code, &:to_s)
    opened Date.today - 3.years
    address

    trait :incorrect_vd do
      before(:create) do |bankbranch|
        correct_verification_digit = Brazilianbanking.branch_verification_digit(bankbranch.code)
        bankbranch.verificationdigit = Brazilianbanking.skew(correct_verification_digit)
      end
    end

    trait :opens_in_a_month do
      opened Date.today + 1.month
    end

    trait :opens_in_a_year do
      opened Date.today + 1.year
    end
  end
end
