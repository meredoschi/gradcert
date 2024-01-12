class RemoveAdvisements < ActiveRecord::Migration[4.2]
  def change
    drop_table :advisements
  end
end
