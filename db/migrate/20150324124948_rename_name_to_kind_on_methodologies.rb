class RenameNameToKindOnMethodologies < ActiveRecord::Migration[4.2]
  def change
    change_table :methodologies do |t|
      t.rename :name, :kind
    end
  end
end
