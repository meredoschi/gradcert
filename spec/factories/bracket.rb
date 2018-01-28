FactoryBot.define do

  factory :bracket do
    #  Bracket(num: integer, start_cents: integer, finish_cents: integer, unlimited: boolean, taxation_id: integer, created_at: datetime, updated_at: datetime, rate: decimal, deductible_cents: integer)
    taxation

  trait :initial do
    num 1
    start_cents 190398
    finish_cents 282665
    unlimited false
    rate 7.5
    deductible_cents 14280

  end

  trait :second do
    num 2
    start_cents 282666
    finish_cents 375105
    unlimited false
    rate 15
    deductible_cents 35480

  end

  trait :third do
    num 3
    start_cents 375106
    finish_cents 466468
    unlimited false
    rate 22.5
    deductible_cents 63613

  end

  trait :fourth do
    num 4
    start_cents 466469
    finish_cents 0
    unlimited true
    rate 27.5
    deductible_cents 86936
  end

  end

end
