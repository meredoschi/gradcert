class CreateAcademiccategories < ActiveRecord::Migration
  def change
    create_table :academiccategories do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :academiccategories, :name, unique: true
  end
end
