#https://stackoverflow.com/questions/23098047/rails-4-how-to-change-default-value-for-table-column-with-migration
class SchoolyearDefaultHours < ActiveRecord::Migration[4.2]
  def up
    change_column_default :schoolyears, :theory, 0
    change_column_default :schoolyears, :practice, 0

  end

  def down
    change_column_default :schoolyears, :theory, nil
    change_column_default :schoolyears, :practice, nil

  end
end
