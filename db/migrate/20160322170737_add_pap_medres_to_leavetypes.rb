class AddPapMedresToLeavetypes < ActiveRecord::Migration[4.2]
  def change
    add_column :leavetypes, :pap, :boolean, default: false
    add_column :leavetypes, :medres, :boolean, default: false
  end
end
