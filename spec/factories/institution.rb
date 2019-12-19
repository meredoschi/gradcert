# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :institution do
    #  => Institution(id: integer, name: string, institutiontype_id: integer, pap: boolean,
    #  medres: boolean, provisional: boolean, sector: string, address_id: integer,
    #  phone_id: integer, webinfo_id: integer, accreditation_id: integer, undergraduate: boolean,
    # legacycode: integer, abbreviation: string)

    sequence(:name) { |n| (Faker::University.name + (n + 1000).to_s).to_s }

    institutiontype

    trait :special_characters_in_the_abbreviation do
      abbreviation 'XYZˆ'
    end
  end
end
