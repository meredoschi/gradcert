# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :streetname do
    sequence(:designation) { |n| (Faker::Address.street_suffix + (n + rand(100000)).to_s).to_s }
  end
end
