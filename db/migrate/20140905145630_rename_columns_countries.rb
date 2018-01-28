class RenameColumnsCountries < ActiveRecord::Migration
  def change
    change_table :countries do |t|
      t.rename :nome, :brname
      t.rename :numero, :number
    end
  end
end
