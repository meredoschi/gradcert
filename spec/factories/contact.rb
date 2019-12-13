# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :contact do
    user
    sequence(:name) { |n| ('B' + (n + rand(100000)).to_s + Faker::Name.name).to_s }
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

    #   ************************************************************************
  end
end
