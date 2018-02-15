# This will guess the User class
FactoryBot.define do
  factory :state do
   sequence(:abbreviation) {|n| "#{Faker::Address.state_abbr+' '+(n).to_s}" }
   sequence(:name) {|n| "#{Faker::Address.state+' '+(n).to_s}" }
   country
  end
end
