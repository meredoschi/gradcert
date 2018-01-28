class AddProgramidToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :program_id, :integer
  end
end
