require 'rails_helper'

RSpec.describe "researchcenters/index", :type => :view do
  before(:each) do
    assign(:researchcenters, [
      Researchcenter.create!(
        :institution_id => 1,
        :rooms => 2,
        :labs => 3,
        :intlprojectsdone => 4,
        :ongoingintlprojects => 5,
        :domesticprojectsdone => 6,
        :ongoingdomesticprojects => 7
      ),
      Researchcenter.create!(
        :institution_id => 1,
        :rooms => 2,
        :labs => 3,
        :intlprojectsdone => 4,
        :ongoingintlprojects => 5,
        :domesticprojectsdone => 6,
        :ongoingdomesticprojects => 7
      )
    ])
  end

  it "renders a list of researchcenters" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
  end
end
