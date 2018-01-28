class AddPhoneIdToInstitution < ActiveRecord::Migration
  def change
    add_column :institutions, :phone_id, :integer
  end
end
