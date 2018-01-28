class AddExternalToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :externalvenue, :boolean, default: false
  end
end
