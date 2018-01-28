require 'rails_helper'

RSpec.describe "schoolnames/show", type: :view do
  before(:each) do
    @schoolname = assign(:schoolname, Schoolname.create!(
      :name => "Name",
      :previousname => "Previousname",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Previousname/)
    expect(rendered).to match(/false/)
  end
end
