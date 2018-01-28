class RenameColumnsUser < ActiveRecord::Migration
  def change
    rename_column(:users, :paprh, :paplocaladm)
    rename_column(:users, :resmedrh, :medreslocaladm)
    rename_column(:users, :resmed, :medres)
  end
end
