# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :registration do
    #    Registration(id: integer, student_id: integer, schoolyear_id: integer
    #    comment: string, accreditation_id: integer, pap: boolean, medres: boolean,
    #    returned: boolean, finalgrade: float, supportingdocumentation: string,
    #    completion_id: integer, registrationkind_id: integer)

    #    returned --> development attribute - deprecated
    student
    association :schoolyear, factory: %i[schoolyear freshman]
    registrationkind
    completion
    accreditation
    #   ************ Associated models - factories to be created ***************
    finalgrade { 100 }
    #    pap true
    #    medres false
    #   ************************************************************************
  end

  # ***********************************
  #  trait :medres do
  #    medres true
  #    pap false
  #  end
end
