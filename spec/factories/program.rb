# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :program do
    # Program(id: integer, institution_id: integer, programname_id: integer, duration: integer,
    # comment: string, created_at: datetime, updated_at: datetime, pap: boolean, medres: boolean,
    # address_id: integer, internal: boolean, accreditation_id: integer, admission_id: integer,
    # schoolterm_id: integer, professionalspecialty_id: integer
    # previouscode: string, parentid: integer

    programname
    #  schoolterm
    comment 'Test'
    #  institution
    #  accreditation
    #  association :admission, factory: %i[admission zero_amounts]
    pap true
    medres false
    gradcert false

    # http://blog.pardner.com/2012/10/how-to-specify-traits-for-model-associations-in-FactoryBot/
    #  association :accreditation, :factory => [:accreditation, :program]

    # ********************
  end

  trait :annual do
    duration 1

    before(:create) do |program|
      freshman_year = FactoryBot.create(:schoolyear, :freshman, program: program)
      program.schoolyears << freshman_year
    end
  end

  trait :biannual do
    duration 2

    before(:create) do |program|
      freshman_year = FactoryBot.create(:schoolyear, :freshman, program: program)
      sophmore_year = FactoryBot.create(:schoolyear, :sophmore, program: program)
      program.schoolyears << freshman_year
      program.schoolyears << sophmore_year
    end
  end

  trait :medical_residency do
    medres true
    pap false
    gradcert false
  end

  trait :graduate_certificate do
    gradcert true
    pap false
    medres false
  end

  # Used for testing purposes only
  trait :undefined do
    gradcert false
    pap false
    medres false
  end
end
