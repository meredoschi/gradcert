class AddSupplementToAnnotation < ActiveRecord::Migration[4.2]
  def change
    add_column :annotations, :supplement, :string
    add_column :annotations, :integer, :string
  end
end
