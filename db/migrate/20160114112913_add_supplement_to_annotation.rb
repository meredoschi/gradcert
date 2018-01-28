class AddSupplementToAnnotation < ActiveRecord::Migration
  def change
    add_column :annotations, :supplement, :string
    add_column :annotations, :integer, :string
  end
end
