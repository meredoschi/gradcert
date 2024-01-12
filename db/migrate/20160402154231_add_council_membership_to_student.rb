class AddCouncilMembershipToStudent < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :councilmembership, :string, limit: 30
  end
end
