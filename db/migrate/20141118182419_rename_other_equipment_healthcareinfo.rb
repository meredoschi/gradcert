class RenameOtherEquipmentHealthcareinfo < ActiveRecord::Migration
  def change
    change_table :healthcareinfos do |t|
      t.rename :otherequipment, :equipmenthighlights
    end
  end
end
