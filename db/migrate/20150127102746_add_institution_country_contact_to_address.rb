class AddInstitutionCountryContactToAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :institution_id, :integer
    add_column :addresses, :country_id, :integer
    add_column :addresses, :contact_id, :integer
  end
end
