require 'rails_helper'

RSpec.describe "healthcareinfos/edit", :type => :view do
  before(:each) do
    @healthcareinfo = assign(:healthcareinfo, Healthcareinfo.create!(
      :institution_id => 1,
      :totalbeds => 1,
      :icubeds => 1,
      :ambulatoryrooms => 1,
      :labs => 1,
      :emergencyroombeds => 1,
      :otherequipment => "MyString"
    ))
  end

  it "renders the edit healthcareinfo form" do
    render

    assert_select "form[action=?][method=?]", healthcareinfo_path(@healthcareinfo), "post" do

      assert_select "input#healthcareinfo_institution_id[name=?]", "healthcareinfo[institution_id]"

      assert_select "input#healthcareinfo_totalbeds[name=?]", "healthcareinfo[totalbeds]"

      assert_select "input#healthcareinfo_icubeds[name=?]", "healthcareinfo[icubeds]"

      assert_select "input#healthcareinfo_ambulatoryrooms[name=?]", "healthcareinfo[ambulatoryrooms]"

      assert_select "input#healthcareinfo_labs[name=?]", "healthcareinfo[labs]"

      assert_select "input#healthcareinfo_emergencyroombeds[name=?]", "healthcareinfo[emergencyroombeds]"

      assert_select "input#healthcareinfo_otherequipment[name=?]", "healthcareinfo[otherequipment]"
    end
  end
end
