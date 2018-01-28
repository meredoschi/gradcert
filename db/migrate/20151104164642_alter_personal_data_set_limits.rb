class AlterPersonalDataSetLimits < ActiveRecord::Migration
  def change
    change_column :personalinfos, :sex, :string, limit: 1
    change_column :personalinfos, :gender, :string, limit: 1
    change_column :personalinfos, :idnumber, :string, limit: 20
    change_column :personalinfos, :idtype, :string, limit: 15
    change_column :personalinfos, :socialsecuritynumber, :string, limit: 20
  end
end
