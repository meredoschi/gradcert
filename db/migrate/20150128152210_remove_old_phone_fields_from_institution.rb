class RemoveOldPhoneFieldsFromInstitution < ActiveRecord::Migration
  def change
    change_table :institutions do |t|
      t.remove :mainphone
      t.remove :phone2
    end
  end
end
