# This will guess the User class
FactoryBot.define do
  #  => Bankaccount(student_id: integer, bankbranch_id: integer, num: string, verificationdigit: string)
  factory :bankaccount do

    bankaccount_num = (Random.rand(2000) +8000)
    vd=Brazilianbanking.account_verification_digit(bankaccount_num)
    num "#{bankaccount_num}"
    verificationdigit "#{vd}"
  #  num 1
  #  verificationdigit 9

    bankbranch

    trait :incorrect_vd do
      bankaccount_num = (Random.rand(2000) +8000)
      vd=Brazilianbanking.account_verification_digit(bankaccount_num-1) # offset to throw off calculation
      num "#{bankaccount_num}"
      verificationdigit "#{vd}"
    end


  end
end
