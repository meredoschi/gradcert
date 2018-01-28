class CreateProfessionalfamilies < ActiveRecord::Migration
  def change
    drop_table :professionalfamilies if table_exists?(:professionalfamilies)

    create_table :professionalfamilies do |t|
      t.string :name, limit: 100, null: false
      t.integer :subgroup_id
      t.integer :familycode
      t.boolean :pap, default: false
      t.boolean :medres, default: false
      t.timestamps null: false
    end
  end
end
