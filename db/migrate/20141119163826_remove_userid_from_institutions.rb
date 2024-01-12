class RemoveUseridFromInstitutions < ActiveRecord::Migration[4.2]
  def change
    change_table :institutions do |t|
      t.remove :user_id
    end
  end
end
