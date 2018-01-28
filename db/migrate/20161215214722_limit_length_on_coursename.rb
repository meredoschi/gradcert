class LimitLengthOnCoursename < ActiveRecord::Migration
  def change
    change_column :coursenames, :name, :string, limit: 200
  end
end
