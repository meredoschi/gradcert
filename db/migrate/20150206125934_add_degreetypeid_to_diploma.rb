class AddDegreetypeidToDiploma < ActiveRecord::Migration
  def change
    add_reference :diplomas, :degreetype, index: true
    remove_column('diplomas', 'degree')
  end
end
