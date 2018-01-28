# Provides for convenient date manipulation
# refer to lib/dateutils_spec.rb
module Dateutils
  def self.elapsed_to_regular_date(num_days_elapsed)
    Settings.dayone + num_days_elapsed.days
  end

  def self.regular_to_elapsed(dt)
    regular_date_to_days_elapsed(dt)
  end

  def self.days_elapsed_since(dt)
    regular_date_to_days_elapsed(dt)
  end

  def self.regular_date_to_days_elapsed(dt)
    first_calendar_day = Settings.dayone

    @days_elapsed = (dt - first_calendar_day).to_i if dt >= first_calendar_day

    @days_elapsed
  end

  def self.past_month_start
    Date.today.beginning_of_month - 1.month
  end

  def self.past_month_finish
    (Date.today - 1.month).to_date.end_of_month
  end

  # d = Date
  def self.weekday?(dt)
    week_day = dt.wday # Weekday

    (week_day > 0 && week_day < 6)
  end

  # Opposite method
  def self.weekend?(d)
    !weekday?(d)
  end

  def self.day_of_the_week_num(dt)
    dt.wday
  end

  # dt = Date
  def self.previous_weekday(dt)
    case Dateutils.day_of_the_week_num(dt)
    when 0
      dt - 2.day
    when 6
      dt - 1.day
    else
      dt
    end
  end

  def self.to_civil(dt)
    Date.civil(dt.year, dt.month, dt.day)
  end

  def self.holiday?(dt)
    dt_civil = to_civil(dt)

    Holidays.on(dt_civil, :br).present?
  end

  # Alias, for convenience
  # e.g. Convert Payroll daystarted, dayfinished attributes to standard date
  def self.to_gregorian(days_elapsed)
    Dateutils.elapsed_to_regular_date(days_elapsed)
  end
end
