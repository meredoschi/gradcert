class RemovePublicfundinglevelFromCharacteristics < ActiveRecord::Migration
  def change
    change_table :characteristics do |t|
      t.remove :publicfundinglevel
    end
  end
end
