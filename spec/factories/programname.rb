# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :programname do
    sequence(:name) do |n|
      (Faker::Space.constellation + ' ' + (n + rand(100_000)
                                          ).to_s).to_s
    end
  end
end
