class AddWebinfoIdToInstitutions < ActiveRecord::Migration[4.2]
  def change
    add_column :institutions, :webinfo_id, :integer
  end
end
