# This will guess the User class
FactoryBot.define do
  factory :placesavailable do
  #  accredited 20
  #  requested 15
    authorized 12
    allowregistrations true
#   ************ Associated models - factories to be created ***************
    institution_id 1
    schoolterm_id 1
#   ************************************************************************
  end
end
