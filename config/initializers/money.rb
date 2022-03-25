# frozen_string_literal: true

# config/initializers/money.rb
MoneyRails.configure do |config|
  # set the default currency
  config.default_currency = :brl
  config.locale_backend = :i18n
  # March 2022 
  # Money.rounding_mode='ROUND_HALF_EVEN' # When explictly set, this was giving seed errors (due to type conversion).
  # [WARNING] The default rounding mode will change from `ROUND_HALF_EVEN` to `ROUND_HALF_UP` in the next major release. Set it explicitly using `Money.rounding_mode=` to avoid potential problems.

end
