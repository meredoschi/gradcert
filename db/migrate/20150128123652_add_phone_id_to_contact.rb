class AddPhoneIdToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :phone_id, :integer
  end
end
