class IndexSchoolOnMinistrycode < ActiveRecord::Migration[4.2]
  def change
    add_index :schools, :ministrycode, unique: true
  end
end
