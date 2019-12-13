# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  #  => Address(streetname_id: integer, addr: string, complement: string, neighborhood: string
  # municipality_id: integer, postalcode: string, created_at: datetime, updated_at: datetime
  # institution_id: integer, country_id: integer, contact_id: integer, regionaloffice_id: integer
  # program_id: integer, header: string, course_id: integer, internal: boolean, council_id: integer
  #  streetnum: integer, bankbranch_id: integer)
  factory :address do
    streetname
    addr Faker::Address.street_name
    streetnum { rand(1..1000) }
    complement Faker::Address.secondary_address
    municipality
    # postalcode {rand(99999).to_s+"-"+rand(999).to_s}
    postalcode '12345-678' # Brazilian format
    neighborhood 'Centro'
    trait :bankbranch do
      bankbranch_id 1
    end

    trait :contact do
      contact_id 1
    end

    trait :council do
      council_id 1
    end

    trait :institution do
      institution_id 1
    end

    trait :regionaloffice do
      regionaloffice_id 1
    end

    #   ************************************************************************
  end
end
