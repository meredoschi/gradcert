require 'rails_helper'

RSpec.describe "institutions/show", :type => :view do
  before(:each) do
    @institution = assign(:institution, Institution.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Addresscomplement/)
    expect(rendered).to match(/Neighborhood/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Postalcode/)
    expect(rendered).to match(/Mainphone/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
