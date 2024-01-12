class RemoveNameFromContacts < ActiveRecord::Migration[4.2]
  def change
    remove_column('contacts', 'name')
  end
end
