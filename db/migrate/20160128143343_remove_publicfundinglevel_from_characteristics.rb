class RemovePublicfundinglevelFromCharacteristics < ActiveRecord::Migration[4.2]
  def change
    change_table :characteristics do |t|
      t.remove :publicfundinglevel
    end
  end
end
