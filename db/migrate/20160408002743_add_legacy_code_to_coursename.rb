class AddLegacyCodeToCoursename < ActiveRecord::Migration[4.2]
  def change
    add_column :coursenames, :legacycode, :integer
  end
end
