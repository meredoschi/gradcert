class AddUseridToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :user_id, :integer
  end
end
