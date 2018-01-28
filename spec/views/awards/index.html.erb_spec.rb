require 'rails_helper'

RSpec.describe "awards/index", :type => :view do
  before(:each) do
    assign(:awards, [
      Award.create!(
        :name => "Name",
        :year => 1,
        :student_id => 2
      ),
      Award.create!(
        :name => "Name",
        :year => 1,
        :student_id => 2
      )
    ])
  end

  it "renders a list of awards" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
