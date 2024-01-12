class CreateProfessionalspecialties < ActiveRecord::Migration[4.2]
  def change
    create_table :professionalspecialties do |t|
      t.string :name, limit: 100
      t.string :fundapcode, limit: 10
      t.integer :professionalarea_id
      t.timestamps null: false
    end
  end
end
