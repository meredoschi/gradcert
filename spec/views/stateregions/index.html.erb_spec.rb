require 'rails_helper'

RSpec.describe "stateregions/index", :type => :view do
  before(:each) do
    assign(:stateregions, [
      Stateregion.create!(
        :name => "Name",
        :brstate_id => 1
      ),
      Stateregion.create!(
        :name => "Name",
        :brstate_id => 1
      )
    ])
  end

  it "renders a list of stateregions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
