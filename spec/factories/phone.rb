# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :phone do
    main { '11 5555-1099' }

    trait :bankbranch do
      bankbranch_id { 1 }
      other { '11 5555-3080' }
    end

    trait :contact do
      contact_id { 1 }
      mobile { '11 9 5555-1234' }
    end

    trait :council do
      council_id { 1 }
    end

    trait :institution do
      institution_id { 1 }
      fax { '11 5555-4921' }
    end

    trait :regionaloffice do
      regionaloffice_id { 1 }
    end

    #   ************************************************************************
  end
end
