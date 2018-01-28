# Composite index - December 2017
class AddCompositeIndexRegistrationidStartToEvent < ActiveRecord::Migration
  def change
    add_index :events, %i[registration_id start]
  end
end
