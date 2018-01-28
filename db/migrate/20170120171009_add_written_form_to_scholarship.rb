class AddWrittenFormToScholarship < ActiveRecord::Migration
  def change
    add_column :scholarships, :writtenform, :string, limit: 200
    add_column :scholarships, :writtenformpartial, :string, limit: 200
  end
end
