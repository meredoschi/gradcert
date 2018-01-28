class AddCurrentlyEmployedToStudent < ActiveRecord::Migration
  def change
    add_column :students, :nationalhealthcareworker, :boolean, default: false
  end
end
