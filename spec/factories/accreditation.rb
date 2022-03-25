# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :accreditation do
    #  => Accreditation(id: integer, institution_id: integer, start: date, renewal: date,
    # revoked: boolean, revocation: date, comment: string, suspension: date, suspended: boolean,
    # original: boolean, renewed: boolean, program_id: integer, registration_id: integer,
    # confirmed: boolean)

    start { '2017-4-1'.to_date }
    original { true }
    renewed { false }
    suspended { false }
    revoked { false }

    trait :institution do
      # https://stackoverflow.com/questions/41043175/testing-child-model-with-rspec-and-getting-the-error-undefined-method-id
      institution { build(:institution) }
    end

    trait :program do
      program { build(:program) }
    end
  end
end
