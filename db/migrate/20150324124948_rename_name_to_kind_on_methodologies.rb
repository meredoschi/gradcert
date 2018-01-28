class RenameNameToKindOnMethodologies < ActiveRecord::Migration
  def change
    change_table :methodologies do |t|
      t.rename :name, :kind
    end
  end
end
