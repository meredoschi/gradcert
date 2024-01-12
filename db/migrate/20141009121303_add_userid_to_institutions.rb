class AddUseridToInstitutions < ActiveRecord::Migration[4.2]
  def change
    add_column :institutions, :user_id, :integer
  end
end
