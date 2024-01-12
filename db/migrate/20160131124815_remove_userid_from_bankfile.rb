class RemoveUseridFromBankfile < ActiveRecord::Migration[4.2]
  def change
    if table_exists?(:bankfiles)

      change_table :bankfiles do |t|
        t.remove :user_id
      end
      end
    end
end
