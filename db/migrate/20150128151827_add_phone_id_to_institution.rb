class AddPhoneIdToInstitution < ActiveRecord::Migration[4.2]
  def change
    add_column :institutions, :phone_id, :integer
  end
end
