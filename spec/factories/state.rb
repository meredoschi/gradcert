# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :state do
    sequence(:abbreviation) do |n|
      (Faker::Address.state_abbr + ' ' + (rand(100_000) + n).to_s)
        .to_s
    end
    sequence(:name) { |n| (Faker::Address.state + ' ' + (rand(100_000) + n).to_s).to_s }
    # As implemented, no programs were offered in more than one country, all were domestic.
    # country
  end
end
