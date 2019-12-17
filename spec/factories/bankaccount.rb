# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  # student_id: integer, bankbranch_id: integer, num: string, verificationdigit: string
  factory :bankaccount do
    sequence(:num) { |num| Pretty.zerofy_left(num, 8) }

    before(:create) do |bankaccount|
      bankaccount.verificationdigit = Brazilianbanking.account_verification_digit(bankaccount.num)
    end

    bankbranch

    trait :incorrect_vd do
      before(:create) do |bankaccount|
        correct_verification_digit = bankaccount.verificationdigit
        incorrect_verification_digit = Brazilianbanking.skew(correct_verification_digit)
        bankaccount.verificationdigit = incorrect_verification_digit
      end
    end
  end
end
