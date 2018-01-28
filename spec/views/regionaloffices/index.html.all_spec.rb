require 'rails_helper'

RSpec.describe "regionaloffices/index", :type => :view do
  before(:each) do
    assign(:regionaloffices, [
      Regionaloffice.create!(
        :name => "Name",
        :references => "",
        :references => "",
        :references => ""
      ),
      Regionaloffice.create!(
        :name => "Name",
        :references => "",
        :references => "",
        :references => ""
      )
    ])
  end

  it "renders a list of regionaloffices" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
