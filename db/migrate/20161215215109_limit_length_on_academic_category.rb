class LimitLengthOnAcademicCategory < ActiveRecord::Migration
  def change
    change_column :academiccategories, :name, :string, limit: 100
  end
end
