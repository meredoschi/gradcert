class IncreaseStateNameTo80Chars < ActiveRecord::Migration[4.2]
  def change
    change_column :states, :name, :string, limit: 80
  end
end
