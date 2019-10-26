# frozen_string_literal: true

require 'active_support/inflections'
require 'action_view/helpers'
extend ActionView::Helpers
require 'rubygems'

namespace :fixes do
  namespace :experimental do
    desc 'Pre-requisite: rake active_record_doctor:missing_foreign_keys > missing_foreign_keys.txt'
    task missing_foreign_key_migrations: [:environment] do
      begin
        # To run prior executing this task:
        # rake active_record_doctor:missing_foreign_keys > missing_foreign_keys.txt
        # https://github.com/gregnavis/active_record_doctor#detecting-missing-foreign-key-constraints

        missing_keys_fname = 'missing_foreign_keys.txt'

        lines = File.readlines File.join(missing_keys_fname)

        lines.each_with_index do |line, i|
          sleep 1
          puts

          arr = line.split

          table_name = arr[0]

          fname = right_now_in_migration_format + \
                  '_add_foreign_key_constraints_to_' + table_name + '.rb'

          print '# '

          puts fname

          pretty_counter(i, fname.size)
          build_migration_file(arr, fname)
        end
      end
    end

    private

    def pretty_counter(indx, file_name_length)
      num_spaces = file_name_length / 2
      print Pretty.repeat_chars('#', num_spaces)

      print ' '
      n = (indx + 1)
      print n.to_s

      print ' '
      puts Pretty.repeat_chars('#', num_spaces)
    end

    def build_migration_file(arr, fname)
      migration_fname = Rails.root.join('db', 'migrate', fname)
      migration_file = File.open(migration_fname, 'w')

      table_name = arr[0]
      # File header
      migration_class = ' < ActiveRecord::Migration'

      migration_file.puts 'class ' + 'AddForeignKeyConstraintsTo' + table_name
                                                                    .capitalize + migration_class
      migration_file.puts '  def change'

      puts 'class ' + 'AddForeignKeyConstraintsTo' + table_name.capitalize + migration_class
      puts '  def change'

      # body (individual lines with the constraints)
      build_fk_constraints(arr, migration_file)

      # Footer
      puts '  end'
      puts 'end'
      migration_file.puts '  end'
      migration_file.puts 'end'
      migration_file.close
    end

    # Date and time right now expressed in Rails migration format
    def right_now_in_migration_format
      I18n.l(Time.zone.now, format: :migration)
    end

    # Build a line in the migration file for each attribute (fk) needed
    # arr = Attributes array
    def build_fk_constraints(arr, migration_file)
      table_name = arr[0]
      num_attribs = arr.size

      (1..num_attribs - 1).each do |indx|
        print '    add_foreign_key :' + table_name + ', :'
        migration_file.print '    add_foreign_key :' + table_name + ', :'

        attrib = arr[indx].to_s
                          .split('_')[0].to_s
                          .pluralize(2) # https://apidock.com/rails/ActionView/Helpers/TextHelper/pluralize

        puts attrib
        migration_file.puts attrib
      end
    end
  end
end
