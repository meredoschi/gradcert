# Composite index - December 2017
class AddCompositeIndexRegistrationidStartToEvent < ActiveRecord::Migration[4.2]
  def change
    add_index :events, %i[registration_id start]
  end
end
