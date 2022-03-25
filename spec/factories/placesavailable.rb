# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :placesavailable do
    #  accredited 20
    #  requested 15
    authorized { 50 }
    allowregistrations { true }
    institution
    schoolterm
  end
end
