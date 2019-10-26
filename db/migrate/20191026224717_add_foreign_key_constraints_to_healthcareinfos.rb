class AddForeignKeyConstraintsToHealthcareinfos < ActiveRecord::Migration
  def change
    add_foreign_key :healthcareinfos, :institutions
  end
end
