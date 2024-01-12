# frozen_string_literal: true

# https://stackoverflow.com/questions/8660732/get-parent-directory-of-current-directory-in-ruby#8660782
main_dir = File.expand_path('..', Dir.pwd)

migrations_dir = File.join(main_dir, 'db', 'migrate')
puts main_dir
puts migrations_dir
Dir.children(migrations_dir)

Dir.each_child(migrations_dir) do |fname|
  puts fname.to_s
  fpath = File.join(migrations_dir, fname)

  file_obj = File.open(fpath)
  puts '----------------------------------------------------'
  file_text = File.read(file_obj)
  puts file_text
  adjusted_text = file_text.sub! 'ActiveRecord::Migration', 'ActiveRecord::Migration[4.2]'
  puts '||||||||||||||| new syntax |||||||||||||||||||||||||||||||||||||||'
  puts adjusted_text
  puts '||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||'
  File.open(fpath, 'w') { |file| file.write(adjusted_text) }
end

# fixed -->

#
# "rake aborted!
# StandardError: An error has occurred, this and all later migrations canceled:
#
# Directly inheriting from ActiveRecord::Migration is not supported.
# Please specify the Rails release the migration was written for:
#
#   class CreateCountries < ActiveRecord::Migration[4.2]"
#
