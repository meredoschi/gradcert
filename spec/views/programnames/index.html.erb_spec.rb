require 'rails_helper'

RSpec.describe "programnames/index", :type => :view do
  before(:each) do
    assign(:programnames, [
      Programname.create!(
        :name => "Name"
      ),
      Programname.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of programnames" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
