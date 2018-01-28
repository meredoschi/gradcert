class CreateDiplomas < ActiveRecord::Migration
  def change
    create_table :diplomas do |t|
      t.string :degree
      t.integer :profession_id
      t.integer :institution_id
      t.string :externalinstitution
      t.boolean :finished
      t.date :awarded

      t.timestamps
    end
  end
end
