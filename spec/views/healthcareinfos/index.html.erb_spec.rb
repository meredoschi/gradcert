require 'rails_helper'

RSpec.describe "healthcareinfos/index", :type => :view do
  before(:each) do
    assign(:healthcareinfos, [
      Healthcareinfo.create!(
        :institution_id => 1,
        :totalbeds => 2,
        :icubeds => 3,
        :ambulatoryrooms => 4,
        :labs => 5,
        :emergencyroombeds => 6,
        :otherequipment => "Otherequipment"
      ),
      Healthcareinfo.create!(
        :institution_id => 1,
        :totalbeds => 2,
        :icubeds => 3,
        :ambulatoryrooms => 4,
        :labs => 5,
        :emergencyroombeds => 6,
        :otherequipment => "Otherequipment"
      )
    ])
  end

  it "renders a list of healthcareinfos" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => "Otherequipment".to_s, :count => 2
  end
end
