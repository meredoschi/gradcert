class AddPartialtoScholarship < ActiveRecord::Migration[4.2]
  def change
    add_column :scholarships, :partialamount, :integer, default: 0
  end
end
