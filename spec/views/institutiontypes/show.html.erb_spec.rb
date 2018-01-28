require 'rails_helper'

RSpec.describe "institutiontypes/show", :type => :view do
  before(:each) do
    @institutiontype = assign(:institutiontype, Institutiontype.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
