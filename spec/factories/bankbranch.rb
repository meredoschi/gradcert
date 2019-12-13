# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  #  Bankbranch(code: string, name: string, formername: string, verificationdigit: string,
  #  opened: date, address_id: integer, phone_id: integer, numericalcode: integer)
  factory :bankbranch do
    # association :payroll, factory: :payroll
    branch_code = Random.rand(8000..9999)

    # "digito verificador" (dv) in Portuguese
    vd = Brazilianbanking.calculate_verification_digit(branch_code, 4).to_s

    code branch_code.to_s
    verificationdigit vd.to_s
    branch_name = Faker::Address.street_name + ' ' + Random.rand(100).to_s.capitalize
    former_name = branch_name.upcase
    three_years_ago = Date.today - 3.years
    in_a_month = Date.today + 1.month
    in_a_year = Date.today + 1.year

    # http://blog.pardner.com/2012/10/how-to-specify-traits-for-model-associations-in-FactoryBot/
    association :address, factory: %i[address bankbranch]

    name branch_name.to_s
    opened three_years_ago.to_s

    trait :incorrect_vd do
      code 9876
      verificationdigit 5
    end

    trait :opens_in_a_month do
      opened in_a_month.to_s
    end

    trait :opens_in_a_year do
      opened in_a_year.to_s
    end
  end
end
