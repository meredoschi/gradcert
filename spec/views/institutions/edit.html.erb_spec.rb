require 'rails_helper'

RSpec.describe "institutions/edit", :type => :view do
  before(:each) do
    @institution = assign(:institution, Institution.create!(
      :name => "MyString",
      :streetname_id => 1,
      :address => "MyString",
      :addresscomplement => "MyString",
      :neighborhood => "MyString",
      :municipality_id => 1,
      :postalcode => "MyString",
      :mainphone => "MyString",
      :url => "MyString",
      :email => "MyString",
      :institutiontype_id => 1,
      :pap => false,
      :medicalresidency => false,
      :provisional => false
    ))
  end

  it "renders the edit institution form" do
    render

    assert_select "form[action=?][method=?]", institution_path(@institution), "post" do

      assert_select "input#institution_name[name=?]", "institution[name]"

      assert_select "input#institution_streetname_id[name=?]", "institution[streetname_id]"

      assert_select "input#institution_address[name=?]", "institution[address]"

      assert_select "input#institution_addresscomplement[name=?]", "institution[addresscomplement]"

      assert_select "input#institution_neighborhood[name=?]", "institution[neighborhood]"

      assert_select "input#institution_municipality_id[name=?]", "institution[municipality_id]"

      assert_select "input#institution_postalcode[name=?]", "institution[postalcode]"

      assert_select "input#institution_mainphone[name=?]", "institution[mainphone]"

      assert_select "input#institution_url[name=?]", "institution[url]"

      assert_select "input#institution_email[name=?]", "institution[email]"

      assert_select "input#institution_institutiontype_id[name=?]", "institution[institutiontype_id]"

      assert_select "input#institution_pap[name=?]", "institution[pap]"

      assert_select "input#institution_medicalresidency[name=?]", "institution[medicalresidency]"

      assert_select "input#institution_provisional[name=?]", "institution[provisional]"
    end
  end
end
