class AddAccreditationidToInstitutions < ActiveRecord::Migration[4.2]
  def change
    add_column :institutions, :accreditation_id, :integer
  end
end
