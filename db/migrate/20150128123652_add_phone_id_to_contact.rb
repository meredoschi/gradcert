class AddPhoneIdToContact < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :phone_id, :integer
  end
end
