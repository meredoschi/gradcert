class AddWebinfoIdToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :webinfo_id, :integer
  end
end
