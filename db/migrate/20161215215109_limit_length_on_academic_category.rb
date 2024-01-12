class LimitLengthOnAcademicCategory < ActiveRecord::Migration[4.2]
  def change
    change_column :academiccategories, :name, :string, limit: 100
  end
end
