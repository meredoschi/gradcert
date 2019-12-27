# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :professionalfamily do
    # Professionalfamily(id: integer, name: string, subgroup_id: integer, familycode: integer,
    # pap: boolean, medres: boolean, council_id: integer)
    #   ************ Associated models - factories to be created ***************
    sequence(:name) { |n| ('A' + (n + 1000).to_s + Faker::Company.profession).to_s }
    sequence(:familycode) { |n| (n + 9900).to_i.to_s }
    subgroup_id 99 # Subgroup model not seeded
    # council_id  # not currently implemented, e.g. nursing, engineering, etc

    # For future use
    trait :pap do
      pap true
      medres false
    end

    # For future use
    trait :medres do
      medres true
      pap false
    end
  end
end
