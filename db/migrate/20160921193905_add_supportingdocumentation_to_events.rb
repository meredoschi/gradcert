class AddSupportingdocumentationToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :supportingdocumentation, :string
  end
end
