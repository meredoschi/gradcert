require 'rails_helper'

RSpec.describe "institutions/index", :type => :view do
  before(:each) do
    assign(:institutions, [
      Institution.create!(
        :name => "Name",
        :streetname_id => 1,
        :address => "Address",
        :addresscomplement => "Addresscomplement",
        :neighborhood => "Neighborhood",
        :municipality_id => 2,
        :postalcode => "Postalcode",
        :mainphone => "Mainphone",
        :url => "Url",
        :email => "Email",
        :institutiontype_id => 3,
        :pap => false,
        :medicalresidency => false,
        :provisional => false
      ),
      Institution.create!(
        :name => "Name",
        :streetname_id => 1,
        :address => "Address",
        :addresscomplement => "Addresscomplement",
        :neighborhood => "Neighborhood",
        :municipality_id => 2,
        :postalcode => "Postalcode",
        :mainphone => "Mainphone",
        :url => "Url",
        :email => "Email",
        :institutiontype_id => 3,
        :pap => false,
        :medicalresidency => false,
        :provisional => false
      )
    ])
  end

  it "renders a list of institutions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Addresscomplement".to_s, :count => 2
    assert_select "tr>td", :text => "Neighborhood".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Postalcode".to_s, :count => 2
    assert_select "tr>td", :text => "Mainphone".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
