class LimitLengthOnCoursename < ActiveRecord::Migration[4.2]
  def change
    change_column :coursenames, :name, :string, limit: 200
  end
end
