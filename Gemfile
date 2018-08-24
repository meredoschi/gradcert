source 'https://rubygems.org'

# Specific to certain groups
group :assets do
  gem 'coffee-rails', '~> 4.1.0' # Use CoffeeScript for .js.coffee assets and views
  gem 'sass-rails' # http://stackoverflow.com/questions/27126235/sass-or-foundation-error-after-updating-rails-and-other-gems
  gem 'uglifier', '>= 1.3.0' # Compressor for JavaScript assets
end

group :development do
#  gem 'bullet'
  gem 'byebug' #  Dec 2016
  gem 'railroady' # https://github.com/preston/railroady
  gem 'rspec-rails'
  gem 'spring'
  gem 'axlsx', '~> 2.0' # i18n-tasks xlsx-report
  gem 'brakeman' # August 2018
  gem 'rails-erb-lint' # August 2018
end

group :test do
  gem 'rspec'
  gem 'simplecov', require: false
  gem 'webrat'
end

group :test, :development do
  gem 'factory_bot_rails',  :require => false
  gem 'rails-observers' # https://github.com/rails/rails-observers
  gem 'redcarpet'
  gem 'rubocop' # August 2017
  gem 'shoulda-matchers', '~> 3.1' # July 2017
  gem 'json_converter', '~> 0.0.0' # November 2017
end

# General

gem 'active_link_to'
gem 'activerecord-reset-pk-sequence' # https://github.com/splendeo/activerecord-reset-pk-sequence
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
gem 'mini_magick' # http://marsorange.com/files/rmagick_vs_minimagick.pdf
gem 'money'
gem 'money-rails'
gem 'morrisjs-rails'
gem 'paper_trail', '~> 3.0.6'
gem 'passenger'
gem 'pg', '0.20' # Use postgresql as the database for Active Record
gem 'prawn' # June 2016
gem 'prawn-table', '~> 0.2.0'
gem 'priceable'
gem 'rails', '~> 4.2.10'
gem 'rails-fix-permissions'
gem 'ransack', '~> 1.8.0'
gem 'raphael-rails'
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
gem 'yard' # Documentation
gem 'zip-zip'

# gem 'holidays'
# gem 'validates_existence', '>= 0.4'
