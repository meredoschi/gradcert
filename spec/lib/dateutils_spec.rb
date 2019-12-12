# frozen_string_literal: true

require 'rails_helper'

describe Dateutils, type: :helper do
  let(:days_elapsed) { 4000 }

  let(:dt) { Date.today - 200 }

  let(:dt2) { Date.today - 198 }

  let(:dt3) { Date.today - 194 }

  # It is assumed days_elapsed will always be non-negative
  it '-elapsed_to_regular_date(num_days_elapsed)' do
    first_calendar_day = Settings.dayone
    regular_date = first_calendar_day + days_elapsed.days
    expect(regular_date).to eq Dateutils.elapsed_to_regular_date(days_elapsed)
  end

  it '-past_month_start' do
    previous_month_start_dt = Date.today.beginning_of_month - 1.month
    expect(previous_month_start_dt).to eq Dateutils.past_month_start
  end

  it '-past_month_finish' do
    previous_month_finish_dt = (Date.today - 1.month).to_date.end_of_month
    expect(previous_month_finish_dt).to eq Dateutils.past_month_finish
  end

  it '-day_of_the_week_num(dt) aliases wday' do
    day_of_the_week_number = dt.wday

    expect(day_of_the_week_number).to eq(Dateutils.day_of_the_week_num(dt))
  end

  it '-to_gregorian(days_elapsed) aliases elapsed_to_regular_date(days_elapsed)' do
    dt_in_standard_format = Dateutils.elapsed_to_regular_date(days_elapsed)
    expect(dt_in_standard_format).to eq(Dateutils.to_gregorian(days_elapsed))
  end

  # d = Date
  it '-weekday?(dt)' do
    week_day = dt.wday # Weekday

    day_of_week_kind = (week_day > 0 && week_day < 6)

    expect(day_of_week_kind).to eq Dateutils.weekday?(dt)
  end

  it '-weekend?(dt)' do
    day_falls_on_a_weekend = !Dateutils.weekday?(dt)

    expect(day_falls_on_a_weekend).to eq Dateutils.weekend?(dt)
  end

  it '-to_civil(dt)' do
    date_in_civil_format = Date.civil(dt.year, dt.month, dt.day)

    expect(date_in_civil_format).to eq Dateutils.to_civil(dt)
  end

  it '-previous_weekday(dt) some time ago (baseline)' do
    #     res = case dt.wday
    res = case Dateutils.day_of_the_week_num(dt)
          when 0
            dt - 2.day
          when 6
            dt - 1.day
          else
            dt
          end

    expect(res).to eq(Dateutils.previous_weekday(dt))
  end

  it '-previous_weekday(dt) two days before some time ago' do
    #     res = case dt.wday
    res = case Dateutils.day_of_the_week_num(dt2)
          when 0
            dt2 - 2.day
          when 6
            dt2 - 1.day
          else
            dt2
          end

    expect(res).to eq(Dateutils.previous_weekday(dt2))
  end

  it '-previous_weekday(dt) six days before some time ago' do
    #     res = case dt.wday
    res = case Dateutils.day_of_the_week_num(dt3)
          when 0
            dt3 - 2.day
          when 6
            dt3 - 1.day
          else
            dt3
          end

    expect(res).to eq(Dateutils.previous_weekday(dt3))
  end

  it '-regular_to_elapsed(dt) regular_date_to_days_elapsed(dt)' do
    regular_dt_to_elapsed = Dateutils.regular_to_elapsed(dt)
    expect(regular_dt_to_elapsed).to eq Dateutils.regular_date_to_days_elapsed(dt)
  end

  it '-regular_date_to_days_elapsed(dt)' do
    first_calendar_day = Settings.dayone

    @days_elapsed = (dt - first_calendar_day).to_i if dt >= first_calendar_day

    expect(@days_elapsed).to eq Dateutils.regular_date_to_days_elapsed(dt)
  end

  it '-days_elapsed_since(dt) aliases regular_date_to_days_elapsed(dt)' do
    num_days_elapsed_since = Dateutils.regular_date_to_days_elapsed(dt)
    expect(num_days_elapsed_since).to eq Dateutils.days_elapsed_since(dt)
  end

  it '-holiday?(dt)' do
    dt_civil = Dateutils.to_civil(dt)

    bank_holiday_status = Holidays.on(dt_civil, :br).present?

    expect(bank_holiday_status).to eq Dateutils.holiday?(dt)
  end
end
