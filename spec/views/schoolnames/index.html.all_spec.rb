require 'rails_helper'

RSpec.describe "schoolnames/index", type: :view do
  before(:each) do
    assign(:schoolnames, [
      Schoolname.create!(
        :name => "Name",
        :previousname => "Previousname",
        :active => false
      ),
      Schoolname.create!(
        :name => "Name",
        :previousname => "Previousname",
        :active => false
      )
    ])
  end

  it "renders a list of schoolnames" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Previousname".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
