# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :contact do
    user
    sequence(:name) { |n| ('B' + (n + rand(100_000)).to_s + Faker::Name.name).to_s }
    address
    personalinfo

    phone
    webinfo
    role

    trait :pap_student_role do
      association :user, factory: %i[user pap]
      association :role, factory: %i[role pap_student]
      association :personalinfo, factory: %i[personalinfo with_mothers_name_and_ssn]
    end

    trait :admin do
      association :user, factory: %i[user admin]
      association :role, factory: %i[role itstaff]
    end

    trait :clerical_pap do
      association :user, factory: %i[user paplocaladm]
      association :role, factory: %i[role clerical pap]
    end

    # Inconsistent, used for testing purposes only
    trait :staff_permission_with_student_role do
      association :user, factory: %i[user paplocaladm]
      association :role, factory: %i[role pap_student]
      association :personalinfo, factory: %i[personalinfo with_mothers_name_and_ssn]
    end

    # Inconsistent, used for testing purposes only
    trait :student_permission_with_staff_role  do
      association :user, factory: %i[user pap] # regular user permission
      association :personalinfo, factory: %i[personalinfo with_mothers_name_and_ssn]

      association :role, factory: %i[role clerical pap] # staff
    end

    # Inconsistent, used for testing purposes only
    trait :name_with_blanks do
      association :user, factory: %i[user pap]
      association :role, factory: %i[role pap_student]
      association :personalinfo, factory: %i[personalinfo with_mothers_name_and_ssn]
      name { '  spa  ced' + (rand(100_000)).to_s + Faker::Name.name.to_s }

    end

   end
    #   ************************************************************************
  end
