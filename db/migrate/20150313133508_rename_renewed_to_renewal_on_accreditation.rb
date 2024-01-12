class RenameRenewedToRenewalOnAccreditation < ActiveRecord::Migration[4.2]
  def change
    change_table :accreditations do |t|
      t.rename :renewed, :renewal
    end
  end
end
