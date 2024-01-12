class AddCurrentlyEmployedToStudent < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :nationalhealthcareworker, :boolean, default: false
  end
end
