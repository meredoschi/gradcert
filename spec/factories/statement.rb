# This will guess the User class
FactoryBot.define do
  factory :statement do
    # registration_id:, grossamount_cents: , incometax_cents: , socialsecurity_cents
    #  childsupport_cents netamount_cents , bankpayment_id

    # http://blog.pardner.com/2012/10/how-to-specify-traits-for-model-associations-in-FactoryBot/
    association :registration
    association :bankpayment

    #    contact
    #    profession_id 1
    #    bankaccount
    #    schoolterm_id 1
    #   ************************************************************************
  end
end
