class RemoveNameFromContacts < ActiveRecord::Migration
  def change
    remove_column('contacts', 'name')
  end
end
