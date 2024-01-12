class RemoveNewApprovedActiveFromPrograms < ActiveRecord::Migration[4.2]
  def change
    change_table :programs do |t|
      t.remove :active
      t.remove :new
      t.remove :approved
    end
  end
end
