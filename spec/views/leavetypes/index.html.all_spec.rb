require 'rails_helper'

RSpec.describe "leavetypes/index", type: :view do
  before(:each) do
    assign(:leavetypes, [
      Leavetype.create!(
        :name => "Name",
        :paid => false,
        :comment => "Comment"
      ),
      Leavetype.create!(
        :name => "Name",
        :paid => false,
        :comment => "Comment"
      )
    ])
  end

  it "renders a list of leavetypes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
  end
end
