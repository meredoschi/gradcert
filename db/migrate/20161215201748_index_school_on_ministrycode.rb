class IndexSchoolOnMinistrycode < ActiveRecord::Migration
  def change
    add_index :schools, :ministrycode, unique: true
  end
end
