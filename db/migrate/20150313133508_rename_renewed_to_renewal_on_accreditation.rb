class RenameRenewedToRenewalOnAccreditation < ActiveRecord::Migration
  def change
    change_table :accreditations do |t|
      t.rename :renewed, :renewal
    end
  end
end
