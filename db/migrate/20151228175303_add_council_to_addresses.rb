class AddCouncilToAddresses < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :council_id, :integer
  end
end
