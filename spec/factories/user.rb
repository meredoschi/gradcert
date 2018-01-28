# This will guess the User class
FactoryBot.define do
  factory :user do
# User(email: string, encrypted_password: string, reset_password_token: string, reset_password_sent_at: datetime, remember_created_at: datetime, sign_in_count: integer, current_sign_in_at: datetime, last_sign_in_at: datetime, current_sign_in_ip: inet, last_sign_in_ip: inet, created_at: datetime, updated_at: datetime, institution_id: integer, permission_id: integer)
#   ************ Associated models - factories to be created ***************
    sample_pass="sample-pass"
  #  email Faker::Internet.email
    sequence(:email) {|n| "#{'A'+(n+1000).to_s+Faker::Internet.email}" }

#    password "sample-pass"
#    password_confirmation "sample-pass"
    password sample_pass
    password_confirmation sample_pass
    institution_id 1
    permission

    # Pap = default (student)

    # http://blog.pardner.com/2012/10/how-to-specify-traits-for-model-associations-in-FactoryBot/
    trait :paplocaladm do
      association :permission, :factory => [:permission, :paplocaladm]
    end

    trait :papmgr do
      association :permission, :factory => [:permission, :papmgr]
    end

    # Medical residency

    trait :medres do
      association :permission, :factory => [:permission, :medres]
    end

    trait :medreslocaladm do
      association :permission, :factory => [:permission, :medreslocaladm]
    end

    trait :medresmgr do
      association :permission, :factory => [:permission, :medresmgr]
    end

    # Admin and read-only
    trait :admin do
      association :permission, :factory => [:permission, :admin]
    end

    trait :adminreadonly do
      association :permission, :factory => [:permission, :adminreadonly]
    end

#   ************************************************************************
  end
end
