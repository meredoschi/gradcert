class IncreaseStateNameTo80Chars < ActiveRecord::Migration
  def change
    change_column :states, :name, :string, limit: 80
  end
end
