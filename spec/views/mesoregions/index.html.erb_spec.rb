require 'rails_helper'

RSpec.describe "mesoregions/index", :type => :view do
  before(:each) do
    assign(:mesoregions, [
      Mesoregion.create!(
        :name => "Name",
        :brstate_id => 1
      ),
      Mesoregion.create!(
        :name => "Name",
        :brstate_id => 1
      )
    ])
  end

  it "renders a list of mesoregions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
