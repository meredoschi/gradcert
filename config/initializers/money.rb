# frozen_string_literal: true

# config/initializers/money.rb
MoneyRails.configure do |config|
  # set the default currency
  config.default_currency = :brl
  config.locale_backend = :i18n
end
