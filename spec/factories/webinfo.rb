# This will guess the User class
FactoryBot.define do

  #  => Webinfo(email: string, site: string, facebook: string, twitter: string, other: string, institution_id: integer, contact_id: integer, created_at: datetime, updated_at: datetime, regionaloffice_id: integer, council_id: integer)

  factory :webinfo do

    email Faker::Internet.email

    trait :bankbranch do
      bankbranch_id 1
      site Faker::Internet.domain_name
    end

    trait :contact do
      contact_id 1
      twitter "#"+Faker::Internet.domain_word
    end

    trait :council do
      council_id 1

    end

    trait :institution do
      site Faker::Internet.domain_name
    end

    trait :regionaloffice do
      regionaloffice_id 1
      facebook Faker::Internet.slug
    end

#   ************************************************************************
  end
end
