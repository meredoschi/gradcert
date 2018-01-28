require 'rails_helper'

RSpec.describe "characteristics/index", :type => :view do
  before(:each) do
    assign(:characteristics, [
      Characteristic.create!(
        :institution_id => 1,
        :mission => "Mission",
        :corevalues => "Corevalues",
        :userprofile => "Userprofile",
        :stateregion_id => 2,
        :relationwithpublichealthcare => "Relationwithpublichealthcare",
        :publicfundinglevel => 1.5,
        :highlightareas => "Highlightareas"
      ),
      Characteristic.create!(
        :institution_id => 1,
        :mission => "Mission",
        :corevalues => "Corevalues",
        :userprofile => "Userprofile",
        :stateregion_id => 2,
        :relationwithpublichealthcare => "Relationwithpublichealthcare",
        :publicfundinglevel => 1.5,
        :highlightareas => "Highlightareas"
      )
    ])
  end

  it "renders a list of characteristics" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Mission".to_s, :count => 2
    assert_select "tr>td", :text => "Corevalues".to_s, :count => 2
    assert_select "tr>td", :text => "Userprofile".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Relationwithpublichealthcare".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Highlightareas".to_s, :count => 2
  end
end
