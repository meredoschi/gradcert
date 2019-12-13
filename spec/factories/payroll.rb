# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :payroll do
    # Payroll(id: integer, paymentdate: date, comment: string, amount_cents: integer,
    # taxation_id: integer, monthworked: date, scholarship_id: integer, special: boolean,
    # daystarted: integer, dayfinished: integer, annotated: boolean, pap: boolean,
    # medres: boolean, done: boolean)

    this_months_beginning = Date.today.beginning_of_month
    next_months_beginning = this_months_beginning + 1.month
    pay_day_on_the_tenth = next_months_beginning + 9.day

    #    monthworked {this_months_beginning}
    #   paymentdate {pmt_date_on_the_tenth} # 10th day
    #    dataentrystart {next_months_beginning-3.days}
    #    dataentryfinish {next_months_beginning+2.days}

    sequence(:monthworked) { |n| (this_months_beginning + n.month).to_s }
    sequence(:paymentdate) { |n| (pay_day_on_the_tenth + n.month).to_s }

    sequence(:dataentrystart) { |n| (next_months_beginning - 3.days + n.month).to_s }
    sequence(:dataentryfinish) { |n| (next_months_beginning + 2.days + n.month).to_s }

    pap true # Default, since medres is reserved for future use
    medres false
    annotated false
    special false
    comment 'Test'

    # For future use
    trait :medres do
      medres true
      pap false
    end

    trait :annotated do
      annotated true
    end

    trait :special do
      special true
    end

    trait :personal_taxation do
      before(:create) do |payroll|
        personal_tax = FactoryBot.create(:taxation, :personal)

        payroll.taxation = personal_tax
      end
    end

    trait :payment_date_in_the_future

    before(:create) do |payroll|
      payroll.paymentdate += 3.months
    end
  end
end
