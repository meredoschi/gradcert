# This will guess the User class
FactoryBot.define do
  factory :registrationkind do
# Registrationkind(id: integer, regular: boolean, makeup: boolean, repeat: boolean, veteran: boolean, previousregistrationid: integer, created_at: datetime, updated_at: datetime, registration_id: integer)
    regular true
    makeup false
    repeat false
  end
  
end
