class RenameColumnsCountries < ActiveRecord::Migration[4.2]
  def change
    change_table :countries do |t|
      t.rename :nome, :brname
      t.rename :numero, :number
    end
  end
end
