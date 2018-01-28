class AddInstitutionCountryContactToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :institution_id, :integer
    add_column :addresses, :country_id, :integer
    add_column :addresses, :contact_id, :integer
  end
end
