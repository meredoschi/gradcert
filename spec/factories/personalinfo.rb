# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :personalinfo do
    #  Personalinfo(sex: string, gender: string, dob: date, idtype: string, idnumber: string,
    #  state_id: integer, country_id: integer, socialsecuritynumber: string, tin: string,
    #  othername: string, contact_id: integer, mothersname: string)

    #    home_state_abbreviation = Settings.home_state_abbreviation
    dob Faker::Date.birthday(18, 70)
    idtype Settings.personaldocument.state_registration
    # association :contact_id, [:contact, :clerical_pap]
    # association :contact, [:clerical_pap]
    # association :contact, [:pap_student_role]

    sequence(:tin) { |n| Brazilianbanking.generate_cpf((100_000_000 + n + rand(100_000)).to_s).to_s }
    sequence(:idnumber) { |n| (10_000 + n).to_s.to_s }
    sex 'F'
    state
    #   country

    trait :with_mothers_name_and_ssn do
      sequence(:socialsecuritynumber) do |n|
        Brazilianbanking
          .generate_nit((1_000_000_020 + n + rand(10_000)).to_s).to_s
      end
      sequence(:mothersname) { |n| ('A' + (n + 1000).to_s + Faker::Name.name).to_s }
    end
  end
end
