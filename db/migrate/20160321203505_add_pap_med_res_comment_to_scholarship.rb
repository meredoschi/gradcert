class AddPapMedResCommentToScholarship < ActiveRecord::Migration[4.2]
  def change
    add_column :scholarships, :pap, :boolean, default: false
    add_column :scholarships, :medres, :boolean, default: false
    add_column :scholarships, :comment, :string, limit: 150
  end
end
