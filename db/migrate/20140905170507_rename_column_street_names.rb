class RenameColumnStreetNames < ActiveRecord::Migration[4.2]
  def change
    change_table :streetnames do |t|
      t.rename :nome, :designation
    end
  end
end
