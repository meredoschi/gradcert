# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :student do
    # Student(id: integer, contact_id: integer, profession_id: integer,
    # bankaccount_id: integer, previouscode: integer, schoolterm_id: integer
    # previousparticipant: boolean, nationalhealthcareworker: boolean)
    #   ************ Associated models - factories to be created ***************
    association :contact, factory: %i[contact pap_student_role]
    profession

   #  To do: recheck bankbranch, address, state, country factories and model tests
   #  bankaccount
    #   ************************************************************************
  end
end
