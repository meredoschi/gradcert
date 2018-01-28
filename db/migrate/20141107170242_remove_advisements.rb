class RemoveAdvisements < ActiveRecord::Migration
  def change
    drop_table :advisements
  end
end
