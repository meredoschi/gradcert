require 'rails_helper'

RSpec.describe "bankbranches/index", type: :view do
  before(:each) do
    assign(:bankbranches, [
      Bankbranch.create!(
        :num => 1,
        :name => "Name",
        :formername => "Formername",
        :municipality_id => 2
      ),
      Bankbranch.create!(
        :num => 1,
        :name => "Name",
        :formername => "Formername",
        :municipality_id => 2
      )
    ])
  end

  it "renders a list of bankbranches" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Formername".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
