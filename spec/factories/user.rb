# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :user do
    sample_pass = 'sample-pass'
    sequence(:email) { |n| ('Sample' + (n + 1000).to_s + Faker::Internet.email).to_s }
    password sample_pass
    password_confirmation sample_pass
    institution
    permission

    trait :pap do
      association :permission, factory: %i[permission pap]
    end

    # http://blog.pardner.com/2012/10/how-to-specify-traits-for-model-associations-in-FactoryBot/
    trait :paplocaladm do
      association :permission, factory: %i[permission paplocaladm]
    end

    trait :papmgr do
      association :permission, factory: %i[permission papmgr]
    end

    trait :papcollaborator do
      association :permission, factory: %i[permission papcollaborator]
    end

    # Medical residency

    trait :medres do
      association :permission, factory: %i[permission medres]
    end

    trait :medreslocaladm do
      association :permission, factory: %i[permission medreslocaladm]
    end

    trait :medresmgr do
      association :permission, factory: %i[permission medresmgr]
    end

    trait :medrescollaborator do
      association :permission, factory: %i[permission medrescollaborator]
    end

    # Admin and read-only
    trait :admin do
      association :permission, factory: %i[permission admin]
    end

    trait :adminreadonly do
      association :permission, factory: %i[permission adminreadonly]
    end
  end
end
