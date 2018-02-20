# This will guess the User class
FactoryBot.define do
  factory :registrationkind do
    # Registrationkind(id: integer, regular: boolean, makeup: boolean, repeat: boolean,
    # veteran: boolean, previousregistrationid: integer, registration_id: integer)

    regular true # Most registrations are "normal" (default)
    makeup false
    repeat false
#    registration
  end

  trait :makeup do
    regular false
    makeup true
    repeat false
  end

  trait :repeat do
    regular false
    makeup false
    repeat true
  end
end
