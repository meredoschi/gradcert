# This will guess the User class
FactoryBot.define do
  factory :scholarship do
# Scholarship(amount_cents: integer, start: date, finish: date, pap: boolean, medres: boolean, comment: string, partialamount_cents: integer, name: string, daystarted: integer, dayfinished: integer, writtenform: string, writtenformpartial: string)
    # For future use
    name "'Programa Teste'"
    pap true # Default, since medres is reserved for future use
    medres false

    trait :medres do
      name "'Programa de Residência Médica'"
      medres true
      pap false
      amount_cents 300000
      partialamount_cents 250000 # Pap has only one scholarship amount.  Medical residency has two: 100% and 80% (partial)

    end

    trait :pap do

    name "'Programa de Aprimoramento Profissional'"
    pap true # Default, since medres is reserved for future use
    medres false
    amount_cents 104470
    partialamount_cents 0 # Pap has only one scholarship amount.  Medical residency has two: 100% and 80% (partial)
    writtenform "hum mil quarenta e quatro reais e setenta centavos"
    start '2000-3-1' # Arbitrary dates in the past (for testing)
    finish '2001-2-28'

    end

  end
end
