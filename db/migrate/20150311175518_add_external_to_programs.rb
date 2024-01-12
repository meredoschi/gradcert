class AddExternalToPrograms < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :externalvenue, :boolean, default: false
  end
end
