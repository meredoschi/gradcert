require 'rails_helper'

RSpec.describe "characteristics/new", :type => :view do
  before(:each) do
    assign(:characteristic, Characteristic.new(
      :institution_id => 1,
      :mission => "MyString",
      :corevalues => "MyString",
      :userprofile => "MyString",
      :stateregion_id => 1,
      :relationwithpublichealthcare => "MyString",
      :publicfundinglevel => 1.5,
      :highlightareas => "MyString"
    ))
  end

  it "renders new characteristic form" do
    render

    assert_select "form[action=?][method=?]", characteristics_path, "post" do

      assert_select "input#characteristic_institution_id[name=?]", "characteristic[institution_id]"

      assert_select "input#characteristic_mission[name=?]", "characteristic[mission]"

      assert_select "input#characteristic_corevalues[name=?]", "characteristic[corevalues]"

      assert_select "input#characteristic_userprofile[name=?]", "characteristic[userprofile]"

      assert_select "input#characteristic_stateregion_id[name=?]", "characteristic[stateregion_id]"

      assert_select "input#characteristic_relationwithpublichealthcare[name=?]", "characteristic[relationwithpublichealthcare]"

      assert_select "input#characteristic_publicfundinglevel[name=?]", "characteristic[publicfundinglevel]"

      assert_select "input#characteristic_highlightareas[name=?]", "characteristic[highlightareas]"
    end
  end
end
