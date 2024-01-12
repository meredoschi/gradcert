class RemoveOldPhoneFieldsFromInstitution < ActiveRecord::Migration[4.2]
  def change
    change_table :institutions do |t|
      t.remove :mainphone
      t.remove :phone2
    end
  end
end
