class AddCouncilMembershipToStudent < ActiveRecord::Migration
  def change
    add_column :students, :councilmembership, :string, limit: 30
  end
end
