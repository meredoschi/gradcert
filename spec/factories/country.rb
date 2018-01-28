# This will guess the User class
FactoryBot.define do
  factory :country do
    # https://stackoverflow.com/questions/12765252/in-FactoryBot-any-way-to-refer-to-the-value-of-field1-when-initializing-field2
   sequence(:name)  {|n| "#{Faker::Address.country+(n+1000).to_s.upcase}" }
   sequence(:brname)  {|n| "#{Faker::Address.country+(n+1000).to_s.capitalize}" }
   a2 "BR"
   a3 "BRA"
  end
end