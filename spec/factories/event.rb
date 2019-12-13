# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    #  Event(start: date, finish: date, leavetype_id: integer, absence: boolean,
    #  registration_id: integer, daystarted: integer, dayfinished: integer, annotation_id: integer,
    #  residual: boolean, confirmed: boolean, archived: boolean, supportingdocumentation: string)

    today = Date.today
    one_year_ago = (today - 1.year)

    two_months_from_now = today + 2.month

    this_months_beginning = today.beginning_of_month
    next_months_beginning = this_months_beginning + 1.month

    #   reg_id=(Random.rand(1000))
    #   latest_payroll=Payroll.latest.first
    reg_ids_active_today = Registration.contextual_today.active.pluck(:id)

    #     start "#{latest_payroll.start+offset.days}"
    #   finish "#{latest_payroll.start+(duration+offset).days}"
    #   leavetype_id 1
    sequence(:registration_id) { |n| (reg_ids_active_today[n]).to_s }

    confirmed true
    processed false

    trait :past do
      processed true
    end

    trait :current do
      processed false
    end

    trait :holiday do
      #       vacation_leave=Leavetype.where(vacation: true).first

      #       leavetype_id "#{vacation_leave.id}"
    end

    trait :started_a_year_ago do
      start { one_year_ago }
    end

    trait :start_two_months_from_now do
      start { two_months_from_now }
    end

    trait :pending do
      confirmed false
    end

    trait :processed do
      processed true
    end

    trait :absence do
      absence true
      start { this_months_beginning }
      finish { this_months_beginning + rand(10).days }
    end
  end
end
