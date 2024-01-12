class AddDegreetypeidToDiploma < ActiveRecord::Migration[4.2]
  def change
    add_reference :diplomas, :degreetype, index: true
    remove_column('diplomas', 'degree')
  end
end
