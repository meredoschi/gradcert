class AddGraduateCertificateToProgramnames < ActiveRecord::Migration[4.2]
  def change
    add_column :programnames, :gradcert, :boolean, default: false
  end
end
