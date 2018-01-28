class CreateFundings < ActiveRecord::Migration
  def change
    create_table :fundings do |t|
      t.integer :government
      t.integer :agreements
      t.integer :privatesector
      t.integer :other
      t.integer :ppp
      t.boolean :percentvalues, default: false
      t.string :comment
      t.timestamps null: false
    end
  end
end
