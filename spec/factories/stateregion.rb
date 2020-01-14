# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :stateregion do
    # http://stackoverflow.com/questions/3482149/how-do-i-pick-randomly-from-an-array
    sequence(:name) { |n| (Faker::Compass.ordinal + ' '+n.to_s) }
    state
  end
end
