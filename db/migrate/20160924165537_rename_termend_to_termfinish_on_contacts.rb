class RenameTermendToTermfinishOnContacts < ActiveRecord::Migration[4.2]
  def change
    change_table :contacts do |t|
      t.rename :termend, :termfinish
    end
  end
end
