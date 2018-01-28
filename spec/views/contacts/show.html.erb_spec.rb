require 'rails_helper'

RSpec.describe "contacts/show", :type => :view do
  before(:each) do
    @contact = assign(:contact, Contact.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Phone2/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
