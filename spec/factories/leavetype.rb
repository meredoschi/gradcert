FactoryBot.define do
  factory :leavetype do
  # Leavetype(id: integer, name: string, paid: boolean, comment: string, setnumdays: integer, dayspaidcap: integer, pap: boolean, medres: boolean, maximumlimit: integer, vacation: boolean)

  # ["Amamentação", "Doação de sangue", "Eleição", "Férias", "Gala", "INSS"
  # "Maternidade", "Nojo", "Particular", "Paternidade", "Saúde"]

  # Paid leaves

  #  **** To do ********

  #dayspaidcap
  name "#{I18n.t('definitions.leavetype.paid.sick')}"

  maxnumdays 366

  trait :honeymoon do
    name I18n.t('definitions.leavetype.paid.honeymoon')
    paid true
  end

  trait :days_paid_cap_consistent do
    dayspaidcap 10
    maxnumdays 20
  end

  trait :days_paid_cap_inconsistent do
    dayspaidcap 400
  end

#  name "Sample"
 # *********************
  trait :pap do
    pap true
    medres false
  end

  trait :medres do
    medres true
    pap false
  end

  trait :sick do
    name "#{I18n.t('definitions.leavetype.paid.sick')}"
    paid true
  end

=begin

  trait :blood_donation do
    name I18n.t('definitions.leavetype.paid.blood_donation')
    paid true
  end

  trait :election do
    name I18n.t('definitions.leavetype.paid.election')
    paid true
  end

  trait :vacation do
    name I18n.t('definitions.leavetype.paid.vacation')
    paid true
  end

  trait :maternity do
    name I18n.t('definitions.leavetype.paid.maternity')
    paid true
#    setnumdays 120
  end

  trait :bereavement do
    name I18n.t('definitions.leavetype.paid.bereavement')
    paid true
#    dayspaidcap 2
  end

  trait :paternity do
    name I18n.t('definitions.leavetype.paid.paternity')
    paid true
  end

  trait :sick do
    name I18n.t('definitions.leavetype.paid.sick')
    paid true
  end

  # Unpaid

  trait :breast_feeding do
    name I18n.t('definitions.leavetype.unpaid.breast_feeding')
    paid false
  end

  trait :social_security do
    name I18n.t('definitions.leavetype.unpaid.social_security')
    paid false
  end

  trait :personal do
    name I18n.t('definitions.leavetype.unpaid.personal')
    paid false
  end

=end

  end

end
