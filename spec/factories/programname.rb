# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :programname do
    sequence(:name) { |n| (Faker::Space.constellation + ' ' + (n + rand(100000)
 ).to_s).to_s }

  end
end
