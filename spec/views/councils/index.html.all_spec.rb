require 'rails_helper'

RSpec.describe "councils/index", type: :view do
  before(:each) do
    assign(:councils, [
      Council.create!(
        :name => "Name",
        :address_id => 1,
        :phone_id => 2,
        :webinfo_id => 3,
        :state_id => 4
      ),
      Council.create!(
        :name => "Name",
        :address_id => 1,
        :phone_id => 2,
        :webinfo_id => 3,
        :state_id => 4
      )
    ])
  end

  it "renders a list of councils" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
