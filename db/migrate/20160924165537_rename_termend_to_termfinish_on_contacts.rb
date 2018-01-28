class RenameTermendToTermfinishOnContacts < ActiveRecord::Migration
  def change
    change_table :contacts do |t|
      t.rename :termend, :termfinish
    end
  end
end
