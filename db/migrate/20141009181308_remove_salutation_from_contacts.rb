class RemoveSalutationFromContacts < ActiveRecord::Migration[4.2]
  def change
    remove_column('contacts', 'salutation')
  end
end
