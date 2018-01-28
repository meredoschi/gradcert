class RemoveSalutationFromContacts < ActiveRecord::Migration
  def change
    remove_column('contacts', 'salutation')
  end
end
