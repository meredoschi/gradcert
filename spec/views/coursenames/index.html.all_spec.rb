require 'rails_helper'

RSpec.describe "coursenames/index", :type => :view do
  before(:each) do
    assign(:coursenames, [
      Coursename.create!(
        :name => "Name",
        :active => false
      ),
      Coursename.create!(
        :name => "Name",
        :active => false
      )
    ])
  end

  it "renders a list of coursenames" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
