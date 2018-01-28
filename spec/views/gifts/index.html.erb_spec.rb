require 'rails_helper'

RSpec.describe "gifts/index", :type => :view do
  before(:each) do
    assign(:gifts, [
      Gift.create!(
        :name => "Name"
      ),
      Gift.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of gifts" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
