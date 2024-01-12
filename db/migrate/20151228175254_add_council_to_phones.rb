class AddCouncilToPhones < ActiveRecord::Migration[4.2]
  def change
    add_column :phones, :council_id, :integer
  end
end
