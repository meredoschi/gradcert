# This will guess the User class
FactoryBot.define do
  factory :student do
# Student(id: integer, contact_id: integer, profession_id: integer, created_at: datetime, updated_at: datetime, bankaccount_id: integer, previouscode: integer, schoolterm_id: integer, previousparticipant: boolean, nationalhealthcareworker: boolean)
#   ************ Associated models - factories to be created ***************
    contact
    profession_id 1
    bankaccount
    schoolterm_id 1
#   ************************************************************************
  end
end
