class DropInstitutionFromSupervisor < ActiveRecord::Migration
  def change
    remove_column('supervisors', 'institution_id')
  end
end
