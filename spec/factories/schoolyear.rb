# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :schoolyear do
    # => Schoolyear(id: integer, programyear: integer, program_id: integer, pass: integer,
    # theory: integer, practice: integer)
    # program
  end

  trait :freshman do
    programyear 1
    #  association :program, factory: %i[program annual]
  end

  trait :sophmore do
    programyear 2
    #  association :program, factory: %i[program biannual]
  end
end
