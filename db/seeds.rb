# frozen_string_literal: true

# Adapted from:  http://dennisreimann.de/blog/seeds-for-different-environments/

# https://stackoverflow.com/questions/25648456/i-cant-seem-to-add-config-include-factorygirlsyntaxmethods-to-my-rspec-co
require 'factory_bot'

def model_name_i18n(name)
  I18n.t('activerecord.models.' + name).pluralize.capitalize
end

def loading_message_i18n(tablename)
  '  ** ' + I18n.t('loading').capitalize + " '" + tablename + "'"
end

# When locale is set to English, returns the international version (if it exists)
def retrieve_seed_file(fname, seeds_dir_path, sub_directory_name)
  if I18n.locale == :en

    seed_file_intl = File.join(seeds_dir_path, sub_directory_name, 'international', fname)

    seed_file = if File.exist?(seed_file_intl)

                  seed_file_intl

                else

                  File.join(seeds_dir_path, sub_directory_name, fname)

                end

  end

  seed_file
end

def load(tables, sub_directory_name)
  tables.each do |tablename|
    #    seed_file = "#{Rails.root}/db/seeds/#{tablename}_seed.rb"
    #    seed_file = "#{Rails.root}/db/seeds/new/#{tablename}_seed.rb" # To do: use join

    seeds_dir_path = File.join(Rails.root, 'db', 'seeds')

    fname = tablename + '_seed.rb'

    seed_file = retrieve_seed_file(fname, seeds_dir_path, sub_directory_name)

    if File.exist?(seed_file)
      #  puts '  ** ' + I18n.t('loading').capitalize + " '" + tablename + "'"

      puts loading_message_i18n(tablename)
      require seed_file

    else
      puts 'File not found!' + tablename + '_seed.rb'

    end
  end
end

# Tables used in the institutions menu
def institutions
  puts model_name_i18n('institution')
  %w[institutions]
  #  %w[institutions placesavailable]
end

# Tables used in the people menu
def people
  puts I18n.t('people').capitalize
  #  %w[users contacts contact_personalinfos contact_phones contact_addresses contact_webinfos]
  %w[users]
end

# System tables
def system_tables
  puts I18n.t('system').capitalize
  %w[permissions roles]
end

# Tables used in the definitions menu
def definitions
  puts I18n.t('definition').pluralize.capitalize

  %w[countries states stateregions municipalities streetnames
     schoolterms institutiontypes programnames taxations brackets]
end

# Tables used in the programs menu
def programs
  puts I18n.t('activerecord.models.program').pluralize.capitalize
  %w[professional_specialties_and_areas programs]
end

if Rails.env.test?

else

  load(system_tables, 'system')
  load(definitions, 'definitions')
  load(institutions, 'institutions')
  load(people, 'people')
  # load(programs, 'programs') # sample programs seed under review (for fine tuning).
end
