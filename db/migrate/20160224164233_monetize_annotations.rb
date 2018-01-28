class MonetizeAnnotations < ActiveRecord::Migration
  def change
    change_table :annotations do |t|
      t.rename :discount, :discount_cents
      t.rename :supplement, :supplement_cents
    end
  end
end
