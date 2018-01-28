# This will guess the User class
FactoryBot.define do
  factory :streetname do
   sequence(:designation) {|n| "#{Faker::Address.street_suffix+(n+1000).to_s}" }
  end
end
