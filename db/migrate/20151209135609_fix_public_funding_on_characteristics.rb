class FixPublicFundingOnCharacteristics < ActiveRecord::Migration[4.2]
  def change
    remove_column :characteristics, :publicfundinglevel
    add_column :characteristics, :publicfundinglevel, :integer
  end
end
