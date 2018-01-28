require 'rails_helper'

RSpec.describe "institutiontypes/index", :type => :view do
  before(:each) do
    assign(:institutiontypes, [
      Institutiontype.create!(
        :name => "Name"
      ),
      Institutiontype.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of institutiontypes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
