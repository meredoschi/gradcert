class AddDirectorToRegionaloffice < ActiveRecord::Migration[4.2]
  def change
    add_column :regionaloffices, :directorsname, :string, limit: 120, null: false
  end
end
