class AddGraduateCertificateToPrograms < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :gradcert, :boolean, default: false
  end
end
