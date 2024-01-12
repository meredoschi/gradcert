class DropInstitutionFromSupervisor < ActiveRecord::Migration[4.2]
  def change
    remove_column('supervisors', 'institution_id')
  end
end
