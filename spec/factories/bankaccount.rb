# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  # student_id: integer, bankbranch_id: integer, num: string, verificationdigit: string
  factory :bankaccount do
    bankaccount_num = Random.rand(8000..9999)
    vd = Brazilianbanking.account_verification_digit(bankaccount_num)
    num bankaccount_num.to_s
    verificationdigit vd.to_s
    #  num 1
    #  verificationdigit 9

    bankbranch

    trait :incorrect_vd do
      bankaccount_num = Random.rand(8000..9999)

      slightly_different_bank_account_num = bankaccount_num - 1 # offset to throw off calculation
      vd = Brazilianbanking.account_verification_digit(slightly_different_bank_account_num)

      num bankaccount_num.to_s
      verificationdigit vd.to_s
    end
  end
end
