class AddCouncilToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :council_id, :integer
  end
end
