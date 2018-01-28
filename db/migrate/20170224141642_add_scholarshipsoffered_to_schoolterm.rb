class AddScholarshipsofferedToSchoolterm < ActiveRecord::Migration
  def change
    add_column :schoolterms, :scholarshipsoffered, :integer, default: 0
  end
end
