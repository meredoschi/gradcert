class MonetizeAnnotations < ActiveRecord::Migration[4.2]
  def change
    change_table :annotations do |t|
      t.rename :discount, :discount_cents
      t.rename :supplement, :supplement_cents
    end
  end
end
