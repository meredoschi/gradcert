class RemovePermissionFlagsFromUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :admin
      t.remove :adminreadonly
      # Pap
      t.remove :papmgr
      t.remove :paplocaladm
      t.remove :pap
      t.remove :papcollaborator
      # Medical Residency
      t.remove :medresmgr
      t.remove :medreslocaladm
      t.remove :medres
      t.remove :medrescollaborator
    end
  end
end
