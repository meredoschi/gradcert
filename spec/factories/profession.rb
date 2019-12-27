# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :profession do
    #  => Profession(id: integer, name: string, occupationcode: integer,
    #  professionalfamily_id: integer, asciiname: string

    #  Professionalfamily(id: integer, name: string, subgroup_id: integer,
    #  familycode: integer, pap: boolean, medres: boolean, council_id: integer)
    #   ************ Associated models - factories to be created ***************
    sequence(:name) { |n| ('A' + (n + 1000).to_s + Faker::Company.profession).to_s }
    #    asciiname
    sequence(:occupationcode) { |n| (n + rand(990_000)).to_i.to_s }
    professionalfamily
    #   ************************************************************************
  end
end
