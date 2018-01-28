# This will guess the User class
FactoryBot.define do
#  Bankbranch(code: string, name: string, formername: string, created_at: datetime, updated_at: datetime, verificationdigit:
# string, opened: date, address_id: integer, phone_id: integer, numericalcode: integer)
  factory :bankbranch do
    #association :payroll, factory: :payroll
    branch_code = (Random.rand(2000) +8000)
    vd=Brazilianbanking.calculate_verification_digit(branch_code, 4).to_s # "digito verificador" (dv) in Portuguese
    code "#{branch_code}"
    verificationdigit "#{vd}"
    branch_name=Faker::Address.street_name+' '+Random.rand(100).to_s.capitalize
    former_name=branch_name.upcase
    three_years_ago=Date.today-3.years
    in_a_month=Date.today+1.month
    in_a_year=Date.today+1.year

    # http://blog.pardner.com/2012/10/how-to-specify-traits-for-model-associations-in-FactoryBot/
    association :address, :factory => [:address, :bankbranch]

    name "#{branch_name}"
    opened "#{three_years_ago}"

    trait :incorrect_vd do

      code 9876
      verificationdigit 5

    end

    trait :opens_in_a_month do

      opened "#{in_a_month}"

    end

    trait :opens_in_a_year do

      opened "#{in_a_year}"

    end

  end
end
