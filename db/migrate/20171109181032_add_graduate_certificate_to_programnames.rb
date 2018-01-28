class AddGraduateCertificateToProgramnames < ActiveRecord::Migration
  def change
    add_column :programnames, :gradcert, :boolean, default: false
  end
end
