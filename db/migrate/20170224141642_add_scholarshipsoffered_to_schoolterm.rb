class AddScholarshipsofferedToSchoolterm < ActiveRecord::Migration[4.2]
  def change
    add_column :schoolterms, :scholarshipsoffered, :integer, default: 0
  end
end
