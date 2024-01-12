class RemoveOldPhoneFieldsFromContact < ActiveRecord::Migration[4.2]
  def change
    change_table :contacts do |t|
      t.remove :phone
      t.remove :phone2
      t.remove :mobile
    end
  end
end
