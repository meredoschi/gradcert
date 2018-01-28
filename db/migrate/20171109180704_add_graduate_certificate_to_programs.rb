class AddGraduateCertificateToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :gradcert, :boolean, default: false
  end
end
