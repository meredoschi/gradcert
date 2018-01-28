require 'rails_helper'

RSpec.describe "degreetypes/index", :type => :view do
  before(:each) do
    assign(:degreetypes, [
      Degreetype.create!(
        :name => "Name"
      ),
      Degreetype.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of degreetypes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
