class RemoveUrlEmailFromInstitutions < ActiveRecord::Migration
  def change
    change_table :institutions do |t|
      t.remove :url
      t.remove :email
    end
  end
end
