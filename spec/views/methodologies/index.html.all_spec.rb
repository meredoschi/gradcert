require 'rails_helper'

RSpec.describe "methodologies/index", :type => :view do
  before(:each) do
    assign(:methodologies, [
      Methodology.create!(
        :name => "Name"
      ),
      Methodology.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of methodologies" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
