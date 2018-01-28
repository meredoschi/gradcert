class AddIndexToPersonalInfo < ActiveRecord::Migration
  def change
    add_index :personalinfos, :tin
  end
end
