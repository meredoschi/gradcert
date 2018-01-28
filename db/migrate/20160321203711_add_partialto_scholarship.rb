class AddPartialtoScholarship < ActiveRecord::Migration
  def change
    add_column :scholarships, :partialamount, :integer, default: 0
  end
end
