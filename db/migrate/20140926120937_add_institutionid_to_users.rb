class AddInstitutionidToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :institution_id, :integer
  end
end
