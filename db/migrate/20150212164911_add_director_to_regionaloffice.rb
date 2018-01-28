class AddDirectorToRegionaloffice < ActiveRecord::Migration
  def change
    add_column :regionaloffices, :directorsname, :string, limit: 120, null: false
  end
end
