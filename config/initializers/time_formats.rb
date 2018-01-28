Date::DATE_FORMATS[:month_and_year] = '%m/%Y'
Date::DATE_FORMATS[:dmy] = '%d/%m/%Y'
Date::DATE_FORMATS[:short_ordinal] = ->(date) { date.strftime("%m #{date.day.ordinalize}") }
Time::DATE_FORMATS[:month_and_year] = '%B/%Y'
Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%m #{time.day.ordinalize}") }
Time::DATE_FORMATS[:dmy] = '%d/%m/%Y'
