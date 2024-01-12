class AddIndexToPersonalInfo < ActiveRecord::Migration[4.2]
  def change
    add_index :personalinfos, :tin
  end
end
