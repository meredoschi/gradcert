class AddNameSchooltermIndexToPrograms < ActiveRecord::Migration
  def change
    add_index :programs, %i[programname_id institution_id schoolterm_id], unique: true, name: 'index_programs_on_name_inst_schoolterm'
  end
end
