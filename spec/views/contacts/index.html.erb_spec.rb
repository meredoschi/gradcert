require 'rails_helper'

RSpec.describe "contacts/index", :type => :view do
  before(:each) do
    assign(:contacts, [
      Contact.create!(
        :user_id => "",
        :salutation => "",
        :name => "",
        :email => "",
        :phone => "Phone",
        :phone2 => "Phone2",
        :mobile => "",
        :role_id => "",
        :streetname_id => "",
        :address => "",
        :addresscomplement => "",
        :neighborhood => "",
        :municipality_id => "",
        :postalcode => "",
        :termstart => ""
      ),
      Contact.create!(
        :user_id => "",
        :salutation => "",
        :name => "",
        :email => "",
        :phone => "Phone",
        :phone2 => "Phone2",
        :mobile => "",
        :role_id => "",
        :streetname_id => "",
        :address => "",
        :addresscomplement => "",
        :neighborhood => "",
        :municipality_id => "",
        :postalcode => "",
        :termstart => ""
      )
    ])
  end

  it "renders a list of contacts" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Phone2".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
