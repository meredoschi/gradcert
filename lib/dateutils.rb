# frozen_string_literal: true

# Provides for convenient date manipulation
# refer to lib/dateutils_spec.rb
module Dateutils

  def self.elapsed_to_regular_date(num_days_elapsed)
    Settings.dayone + num_days_elapsed.days
  end

  def self.regular_to_elapsed(specified_dt)
    regular_date_to_days_elapsed(specified_dt)
  end

  def self.days_elapsed_since(specified_dt)
    regular_date_to_days_elapsed(specified_dt)
  end

  def self.regular_date_to_days_elapsed(specified_dt)
    (specified_dt - Settings.dayone).to_i
  end

  def self.past_month_start
    Time.zone.today.beginning_of_month - 1.month
  end

  def self.past_month_finish
    (Time.zone.today - 1.month).to_date.end_of_month
  end

  # d = Date
  def self.weekday?(specified_dt)
    week_day = specified_dt.wday # Weekday

    (week_day.positive? && week_day < 6)
  end

  # Opposite method
  def self.weekend?(specified_dt)
    !weekday?(specified_dt)
  end

  def self.day_of_the_week_num(specified_dt)
    specified_dt.wday
  end

  # specified_dt = Date
  def self.previous_weekday(specified_dt)
    case Dateutils.day_of_the_week_num(specified_dt)
    when 1 # Monday
      specified_dt - 3.days
    when 0 # Sunday
      specified_dt - 2.days
    else # Tuesday (2) thru Saturday (6)
      specified_dt - 1.day
    end
  end

  def self.to_civil(specified_dt)
    Date.civil(specified_dt.year, specified_dt.month, specified_dt.day)
  end

  def self.holiday?(specified_dt)
    specified_dt_civil = to_civil(specified_dt)

    Holidays.on(specified_dt_civil, :br).present?
  end

  # Alias, for convenience
  # e.g. Convert Payroll daystarted, dayfinished attributes to standard date
  def self.to_gregorian(days_elapsed)
    Dateutils.elapsed_to_regular_date(days_elapsed)
  end
end
