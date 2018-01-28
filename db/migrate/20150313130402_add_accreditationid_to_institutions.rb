class AddAccreditationidToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :accreditation_id, :integer
  end
end
