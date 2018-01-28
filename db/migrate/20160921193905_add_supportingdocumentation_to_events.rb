class AddSupportingdocumentationToEvents < ActiveRecord::Migration
  def change
    add_column :events, :supportingdocumentation, :string
  end
end
