class AddSchoolIdPapMedresToCoursename < ActiveRecord::Migration[4.2]
  def change
    add_column :coursenames, :school_id, :integer
    add_column :coursenames, :pap, :boolean, default: false
    add_column :coursenames, :medres, :boolean, default: false
  end
end
