source 'https://rubygems.org'

#ruby "2.5.5" # August 2019
ruby "2.7.2" # March 2022

# Specific to certain groups
group :assets do
  gem 'coffee-rails', '~> 4.1.0' # Use CoffeeScript for .js.coffee assets and views
  gem 'sass-rails' # http://stackoverflow.com/questions/27126235/sass-or-foundation-error-after-updating-rails-and-other-gems
  gem 'uglifier', '>= 1.3.0' # Compressor for JavaScript assets
end

group :development do
#  gem 'bullet'
  gem 'active_record_doctor' # https://github.com/gregnavis/active_record_doctor # October 2019

 #  gem 'axlsx', '~> 3.0.0pre' # i18n-tasks xlsx-report # Rails 5.0.7 update conflict

  gem 'mime-types', '~> 3.3'
  gem 'byebug' #  Dec 2016
  gem 'railroady' # https://github.com/preston/railroady
  gem 'spring'
  gem 'brakeman' # August 2018
  #gem 'rails-erb-lint' # August 2018
end

group :test do
  gem 'simplecov', require: false
  gem 'webrat'
end

group :test, :development do
  gem 'factory_bot_rails', '4.11.0', require: false
  gem 'rails-observers' # https://github.com/rails/rails-observers
  gem 'redcarpet'
  gem 'rubocop', '~> 0.78.0' # December 2019
  # gem 'rubocop-rails', '~> 2.4' # deprecated
  gem 'shoulda-matchers', '~> 3.1' # July 2017
  gem 'json_converter', '~> 0.0.0' # November 2017
  gem 'capybara' # September 2018
  gem 'httparty' # January 2020
  gem 'rspec-rails', '~> 4.0.0' # March 2022
  gem 'rubocop-rspec'
end

# General

gem 'active_link_to'
gem 'activerecord-reset-pk-sequence' # https://github.com/splendeo/activerecord-reset-pk-sequence
gem 'activerecord', '~> 5.0.7' # Added for Rails 5.0.7 - March 2022
gem 'addressable', '~> 2.8'
gem 'bigdecimal', '~> 1.4' # Added for Ruby 2.7 - March 2022
gem 'cancancan'
gem 'carrierwave'
gem 'cocoon'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'devise'
gem 'execjs' # See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'faker'
gem 'ffaker'
gem 'file_validators'
gem 'foundation-rails', '~> 5.5.3' # Version 5
gem 'holidays'
gem 'i18n', '>= 0.6.9'
gem 'i18n-tasks', '~> 0.9.20'
gem 'jbuilder', '~> 1.2' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'kaminari'
gem 'mini_magick', ">= 4.9.4" # http://marsorange.com/files/rmagick_vs_minimagick.pdf
gem 'money'
gem 'money-rails'
gem 'morrisjs-rails'
gem 'nokogiri', ">= 1.13.2"
#gem 'paper_trail', '~> 3.0.6'
gem 'paper_trail', '~> 5.0', '>= 5.0.1' # Rails 5.0.7
gem 'passenger'
gem 'pg', '0.20' # Use postgresql as the database for Active Record
gem 'prawn' # June 2016
gem 'prawn-table', '~> 0.2.0'
gem 'priceable'
#gem 'rails', '~> 4.2.10'
gem 'rails', '~> 5.0.7'
gem 'rails-fix-permissions'
#gem 'ransack', '~> 1.8.0'
gem 'ransack', '~> 2.1', '>= 2.1.1' # Rails 5.0.7 update
gem 'raphael-rails'
#gem "rubyzip", ">= 1.3.0"
gem 'rubyzip', '~> 2.3' # Rails 5.0.7 update March 2022
gem 'seed_dump' # Marcelo - February 2016
gem 'settingslogic'
gem 'simple_xlsx_writer' # Excel export
gem 'therubyracer', platforms: :ruby
gem 'thin'
gem 'timeliness' #  Date validation
gem 'traceroute'
gem 'turbolinks' # Read more: https://github.com/rails/turbolinks
gem 'tzinfo', '~> 1.2.1'
gem 'validates_overlap' # April 2016
gem 'validates_timeliness', '~> 4.0'
gem 'yard', ">= 0.9.20" # Documentation
#gem 'zip-zip'

# gem 'holidays'
# gem 'validates_existence', '>= 0.4'
