class AddProgramidToAddresses < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :program_id, :integer
  end
end
