class AddNameToScholarship < ActiveRecord::Migration
  def change
    add_column :scholarships, :name, :string, limit: 100
  end
end
