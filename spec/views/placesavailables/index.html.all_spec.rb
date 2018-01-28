require 'rails_helper'

RSpec.describe "placesavailables/index", type: :view do
  before(:each) do
    assign(:placesavailables, [
      Placesavailable.create!(
        :institution_id => 1,
        :schoolterm_id => 2,
        :requested => 3,
        :accredited => 4,
        :authorized => 5
      ),
      Placesavailable.create!(
        :institution_id => 1,
        :schoolterm_id => 2,
        :requested => 3,
        :accredited => 4,
        :authorized => 5
      )
    ])
  end

  it "renders a list of placesavailables" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
