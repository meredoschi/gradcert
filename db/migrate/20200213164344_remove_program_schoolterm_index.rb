class RemoveProgramSchooltermIndex < ActiveRecord::Migration
# https://stackoverflow.com/questions/22745757/how-to-remove-index-in-rails
  def change
    remove_index "programs", name: "index_programs_on_schoolterm_id"
  end
end
