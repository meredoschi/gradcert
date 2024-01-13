# frozen_string_literal: true

# https://github.com/RubyMoney/money-rails/issues/614
money_gem_dir = Gem::Specification.find_by_name('money-rails').gem_dir
require "#{money_gem_dir}/lib/money-rails/helpers/action_view_extension"

# config/initializers/money.rb
MoneyRails.configure do |money_config|
  # set the default currency
  money_config.locale_backend = :i18n

  money_config.default_currency = if Rails.application.config.i18n.default_locale == :pt_BR
                                    :brl
                                  else
                                    :eur
                                  end

  # March 2022
  # Money.rounding_mode='ROUND_HALF_EVEN' # When explictly set, this was blocking the seed
  # ** Loading 'brackets'
  # .rvm/gems/ruby-2.7.5@gradcert/gems/activesupport-5.0.7.2/lib/active_support/core_ext/big_decimal/conversions.rb:9: warning: rb_check_safe_obj will be removed in Ruby 3.0
  # rake aborted!
  # TypeError: no implicit conversion of String into Integer

  # [WARNING] The default rounding mode will change from `ROUND_HALF_EVEN` to `ROUND_HALF_UP` in the next major release. Set it explicitly using `Money.rounding_mode=` to avoid potential problems.
end
