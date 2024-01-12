class AddImageToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :image, :string
  end
end
