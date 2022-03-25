# frozen_string_literal: true

FactoryBot.define do
  factory :bracket do
    #  Bracket(num: integer, start_cents: integer, finish_cents: integer, unlimited: boolean,
    #  taxation_id: integer, rate: decimal, deductible_cents: integer)
    taxation

    trait :initial do
      num { 1 }
      start_cents { 190_398 }
      finish_cents { 282_665 }
      unlimited { false }
      rate { 7.5 }
      deductible_cents { 14_280 }
    end

    trait :second do
      num { 2 }
      start_cents { 282_666 }
      finish_cents { 375_105 }
      unlimited { false }
      rate { 15 }
      deductible_cents { 35_480 }
    end

    trait :third do
      num { 3 }
      start_cents { 375_106 }
      finish_cents { 466_468 }
      unlimited { false }
      rate { 22.5 }
      deductible_cents { 63_613 }
    end

    trait :fourth do
      num { 4 }
      start_cents { 466_469 }
      finish_cents { 0 }
      unlimited { true }
      rate { 27.5 }
      deductible_cents { 86_936 }
    end
  end
end
