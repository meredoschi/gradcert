class AddCouncilToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :council_id, :integer
  end
end
