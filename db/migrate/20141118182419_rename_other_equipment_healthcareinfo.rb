class RenameOtherEquipmentHealthcareinfo < ActiveRecord::Migration[4.2]
  def change
    change_table :healthcareinfos do |t|
      t.rename :otherequipment, :equipmenthighlights
    end
  end
end
