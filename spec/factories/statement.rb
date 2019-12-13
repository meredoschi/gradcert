# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :statement do
    # registration_id:, grossamount_cents: , incometax_cents: , socialsecurity_cents
    #  childsupport_cents netamount_cents , bankpayment_id

    # http://blog.pardner.com/2012/10/how-to-specify-traits-for-model-associations-in-FactoryBot/
    association :registration
    association :bankpayment
    grossamount_cents 100
    incometax_cents 0
    socialsecurity_cents 11
    childsupport_cents 0
    netamount_cents 89

    #   ************************************************************************
  end
end
