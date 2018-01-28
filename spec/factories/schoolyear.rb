# This will guess the User class
FactoryBot.define do
  factory :schoolyear do
# => Schoolyear(id: integer, programyear: integer, program_id: integer, pass: integer, theory: integer, practice: integer)
    program
  end

  trait :freshman do
    programyear 1

  end

  trait :sophmore do
    programyear 2

  end

end
