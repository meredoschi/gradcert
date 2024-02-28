# frozen_string_literal: true

source 'https://rubygems.org'

# ruby "2.5.5" # August 2019
# ruby "2.7.5" # March 2022
ruby '3.0.6' # January 2024

# Specific to certain groups
group :assets do
  #  gem 'coffee-rails', '~> 4.1.0' # Use CoffeeScript for .js.coffee assets and views

  # gem 'coffee-rails', '~> 4.2.2' # Use CoffeeScript for .js.coffee assets and views # Rails 5.1.7
  # Rails 6 update
  gem 'coffee-rails', '~> 5.0'

  gem 'uglifier', '>= 1.3.0' # Compressor for JavaScript assets
end

group :development do
  #  gem 'bullet'
  gem 'active_record_doctor' # https://github.com/gregnavis/active_record_doctor # October 2019

  #  gem 'axlsx', '~> 3.0.0pre' # i18n-tasks xlsx-report # Rails 5.0.7 update conflict

  gem 'brakeman' # August 2018
  gem 'byebug' #  Dec 2016
  gem 'mime-types', '~> 3.3'
  gem 'railroady' # https://github.com/preston/railroady
  gem 'spring'
  # gem 'rails-erb-lint' # August 2018
end

group :test do
  gem 'simplecov', require: false
  gem 'webrat'
end

group :test, :development do
  gem 'capybara'
  #  gem 'factory_bot_rails', '4.11.0', require: false
  # Rails 6 update
  # -----
  gem 'factory_bot_rails', '~> 5.2', require: false
  gem 'rspec-rails', '~> 6.1'
  # -----
  gem 'httparty', '~> 0.21.0' # January 2024
  gem 'json_converter', '~> 0.0.0' # November 2017
  gem 'listen' # March 2022 - Rails 5.1.7
  gem 'rails-observers' # https://github.com/rails/rails-observers
  gem 'redcarpet'
  gem 'shoulda-matchers', '~> 3.1' # July 2017
end

# General

# March 2022 - Rails 5.1.7 upgrade

gem 'activerecord-reset-pk-sequence' # https://github.com/splendeo/activerecord-reset-pk-sequence
# gem 'activerecord', '~> 5.0.7' # Added for Rails 5.0.7 - March 2022
# gem 'activerecord', '~> 5.1.7' # Added for Rails 5.1.7 - March 2022
# gem 'activerecord', '~> 5.2.7' # Added for Rails 5.2.7 - March 2022
gem 'addressable', '~> 2.8'
gem 'bootsnap', require: false # Rails 5.2.7 update - March 2022
gem 'cancancan'
gem 'cocoon'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'execjs' # See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'faker'
gem 'ffaker'
gem 'holidays'
gem 'i18n', '>= 0.6.9'
# gem 'jbuilder', '~> 1.2' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

gem 'mini_magick', '>= 4.9.4' # http://marsorange.com/files/rmagick_vs_minimagick.pdf
gem 'nokogiri', '~> 1.16'
# gem 'paper_trail', '~> 3.0.6'
# gem 'paper_trail', '~> 5.0', '>= 5.0.1' # Rails 5.0.7
# gem 'paper_trail', '~> 11.1' # January 2024 Rails 6.0.22
gem 'passenger'
# gem 'pg', '0.20' # Use postgresql as the database for Active Record
gem 'prawn' # June 2016
gem 'prawn-table', '~> 0.2.0'
gem 'priceable'
# gem 'rails', '~> 4.2.10'
# gem 'rails', '~> 5.0.7'
# gem 'rails', '~> 5.1.7'
# gem 'rails', '~> 5.2.7'
### Rails updates
# gem 'rails', '~> 5.2', '>= 5.2.8.1'
###
gem 'globalid', '~> 1.0', '>= 1.0.1'
gem 'rack', '~> 2.2', '>= 2.2.8'
###

gem 'rails-fix-permissions'
# gem 'ransack', '~> 1.8.0'
# gem 'ransack', '~> 2.1', '>= 2.1.1' # Rails 5.0.7 update
#
gem 'raphael-rails'
# gem "rubyzip", ">= 1.3.0"
gem 'rubyzip', '~> 2.3' # Rails 5.0.7 update March 2022
gem 'seed_dump' # Marcelo - February 2016
gem 'settingslogic'
gem 'simple_xlsx_writer' # Excel export
gem 'therubyracer', platforms: :ruby
gem 'thin'
gem 'timeliness' #  Date validation
gem 'traceroute'
gem 'turbolinks' # Read more: https://github.com/rails/turbolinks
gem 'tzinfo'
# commented out on Rails 5.1.7 install
gem 'validates_overlap' # April 2016
gem 'validates_timeliness', '~> 4.0'
gem 'yard', '>= 0.9.20' # Documentation
# gem 'zip-zip'

# gem 'holidays'
# gem 'validates_existence', '>= 0.4'

# Rails 6 update
gem 'actionpack'
gem 'active_link_to'
gem 'activemodel'
gem 'activerecord', '>= 6.1.7.1'
gem 'carrierwave'
gem 'devise'
gem 'file_validators'
gem 'foundation-rails', '~> 5.5.3' # Version 5
gem 'i18n-tasks'
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'kaminari'
gem 'money'
gem 'money-rails'
gem 'morrisjs-rails'
gem 'paper_trail', '~> 15.1'
gem 'paper_trail-association_tracking', '~> 2.2', '>= 2.2.1'
gem 'pg'
gem 'rails', '~> 6.1'
gem 'ransack', '~> 3.2', '>= 3.2.1'
gem 'rubocop-faker'
gem 'rubocop-rails', require: false
gem 'rubocop-rspec'
gem 'sass-rails' # http://stackoverflow.com/questions/27126235/sass-or-foundation-error-after-updating-rails-and-other-gems
gem 'bigdecimal'
gem 'loofah', '~> 2.22'
gem 'rails-html-sanitizer', '~> 1.6'
