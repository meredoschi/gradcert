# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :municipality do
    # http://stackoverflow.com/questions/3482149/how-do-i-pick-randomly-from-an-array
    # name Faker::Address.city

    sample_name = FFaker::AddressBR.city
    sample_ascii_name = I18n.transliterate(sample_name)
    prefix = Settings.abbreviated_state_prefix
    sample_state_abbreviation = Settings.sample_state_abbreviation
    sample_ascii_name_with_state = sample_ascii_name + prefix + sample_state_abbreviation

    stateregion
    codmuni { |n| n }

    sequence(:name) { |n| ('A' + (n + 1000).to_s + sample_name).to_s }
    sequence(:asciinamewithstate) do |n|
      ('A' + (n + 1000).to_s + sample_ascii_name_with_state).to_s
    end
  end
end
