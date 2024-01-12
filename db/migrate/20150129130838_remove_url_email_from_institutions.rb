class RemoveUrlEmailFromInstitutions < ActiveRecord::Migration[4.2]
  def change
    change_table :institutions do |t|
      t.remove :url
      t.remove :email
    end
  end
end
