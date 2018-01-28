FactoryBot.define do
  factory :schoolterm do

    sequence(:start) {|n| "#{'2018-3-1'.to_date+n.years}" }
#    start '2018-3-1'.to_date
    sequence(:finish) {|n| "#{'2019-2-28'.to_date+n.years}" }
#    finish '2019-2-28'.to_date

    sequence(:seasondebut) {|n| "#{'2018-1-15'.to_date+n.years}" }
    sequence(:seasonclosure) {|n| "#{'2018-5-1'.to_date+n.years}" }

    sequence(:admissionsdebut) {|n| "#{'2018-6-1'.to_datetime+n.years}" }
    sequence(:admissionsclosure) {|n| "#{'2018-7-1'.to_datetime+n.years}" }

    scholarshipsoffered 1173

    trait :pap do
      pap true
      medres false
    end

    trait :medres do
      medres true
      pap false
    end

  end
end
