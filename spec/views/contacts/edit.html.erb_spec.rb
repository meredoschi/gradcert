require 'rails_helper'

RSpec.describe "contacts/edit", :type => :view do
  before(:each) do
    @contact = assign(:contact, Contact.create!(
      :user_id => "",
      :salutation => "",
      :name => "",
      :email => "",
      :phone => "MyString",
      :phone2 => "MyString",
      :mobile => "",
      :role_id => "",
      :streetname_id => "",
      :address => "",
      :addresscomplement => "",
      :neighborhood => "",
      :municipality_id => "",
      :postalcode => "",
      :termstart => ""
    ))
  end

  it "renders the edit contact form" do
    render

    assert_select "form[action=?][method=?]", contact_path(@contact), "post" do

      assert_select "input#contact_user_id[name=?]", "contact[user_id]"

      assert_select "input#contact_salutation[name=?]", "contact[salutation]"

      assert_select "input#contact_name[name=?]", "contact[name]"

      assert_select "input#contact_email[name=?]", "contact[email]"

      assert_select "input#contact_phone[name=?]", "contact[phone]"

      assert_select "input#contact_phone2[name=?]", "contact[phone2]"

      assert_select "input#contact_mobile[name=?]", "contact[mobile]"

      assert_select "input#contact_role_id[name=?]", "contact[role_id]"

      assert_select "input#contact_streetname_id[name=?]", "contact[streetname_id]"

      assert_select "input#contact_address[name=?]", "contact[address]"

      assert_select "input#contact_addresscomplement[name=?]", "contact[addresscomplement]"

      assert_select "input#contact_neighborhood[name=?]", "contact[neighborhood]"

      assert_select "input#contact_municipality_id[name=?]", "contact[municipality_id]"

      assert_select "input#contact_postalcode[name=?]", "contact[postalcode]"

      assert_select "input#contact_termstart[name=?]", "contact[termstart]"
    end
  end
end
