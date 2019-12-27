# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :state do
    sequence(:abbreviation) { |n| (Faker::Address.state_abbr + ' ' + (rand(100_000) + n).to_s).to_s }
    sequence(:name) { |n| (Faker::Address.state + ' ' + (rand(100_000) + n).to_s).to_s }
    country
  end
end
