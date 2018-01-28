# This will guess the User class
FactoryBot.define do
  factory :personalinfo do

  #  Personalinfo(sex: string, gender: string, dob: date, idtype: string, idnumber: string, state_id: integer, country_id: integer, socialsecuritynumber: string, created_at: datetime, updated_at: datetime, tin: string, othername: string, contact_id: integer, mothersname: string)

   home_state_abbreviation=Settings.home_state_abbreviation
   dob Faker::Date.birthday(18, 70)
   idtype Settings.personaldocument.state_registration
   # association :contact_id, [:contact, :clerical_pap]
   association :contact, [:clerical_pap]
   sequence(:tin) {|n| "#{Brazilianbanking.generate_cpf(((100000000+n).to_s))}" }
   sequence(:socialsecuritynumber) {|n| "#{Brazilianbanking.generate_nit(((1000000000+n).to_s))}" }
   sequence(:idnumber) {|n| "#{(10000+n).to_s}" }
   sex "F"
   state_id 1
  end
end
