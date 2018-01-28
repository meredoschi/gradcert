class AddPeopleColumnstoHealthcareinfo < ActiveRecord::Migration
  def change
    add_column :healthcareinfos, :consultations, :integer
    add_column :healthcareinfos, :admissions, :integer
    add_column :healthcareinfos, :radiologyprocedures, :integer
    add_column :healthcareinfos, :labexams, :integer
    add_column :healthcareinfos, :surgeries, :integer
  end
end
