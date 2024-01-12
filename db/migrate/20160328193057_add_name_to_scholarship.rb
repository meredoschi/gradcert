class AddNameToScholarship < ActiveRecord::Migration[4.2]
  def change
    add_column :scholarships, :name, :string, limit: 100
  end
end
