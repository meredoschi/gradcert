class RemoveUseridFromInstitutions < ActiveRecord::Migration
  def change
    change_table :institutions do |t|
      t.remove :user_id
    end
  end
end
