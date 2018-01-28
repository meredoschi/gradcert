class RenameColumnStreetNames < ActiveRecord::Migration
  def change
    change_table :streetnames do |t|
      t.rename :nome, :designation
    end
  end
end
