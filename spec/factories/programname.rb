# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :programname do
    sequence(:name) do |n|
      (Faker::Space.constellation + ' ' + rand(65..90).chr + rand(65..90).chr + (n + rand(100_000)
                                                                                ).to_s).to_s
    end

    # used for testing only.
    trait :long_name do
      sequence(:name) do |n|
        (Pretty.repeat_chars('A', rand(100..180)) + rand(65..90).chr + rand(65..90).chr + n.to_s)
      end
    end
  end
end
