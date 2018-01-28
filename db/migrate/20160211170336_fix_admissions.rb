class FixAdmissions < ActiveRecord::Migration
  def change
    change_table :admissions do |t|
      t.rename :started, :start
      t.rename :finished, :finish
      t.rename :approved, :admitted
    end

    add_column :admissions, :program_id, :integer, null: false
  end
end
