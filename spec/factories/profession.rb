# This will guess the User class
FactoryBot.define do
  factory :profession do
  #  => Profession(id: integer, name: string, occupationcode: integer, created_at: datetime, updated_at: datetime, professionalfamily_id: integer, asciiname: string
  # Professionalfamily(id: integer, name: string, subgroup_id: integer, familycode: integer, pap: boolean, medres: boolean, created_at: datetime, updated_at: datetime, council_id: integer)
#   ************ Associated models - factories to be created ***************
    sequence(:name) {|n| "#{'A'+(n+1000).to_s+Faker::Company.profession}" }
#    asciiname
    sequence(:occupationcode) {|n| "#{(n+990000).to_i}" }
    professionalfamily_id 1
#   ************************************************************************
  end
end
