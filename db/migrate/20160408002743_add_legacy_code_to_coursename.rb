class AddLegacyCodeToCoursename < ActiveRecord::Migration
  def change
    add_column :coursenames, :legacycode, :integer
  end
end
