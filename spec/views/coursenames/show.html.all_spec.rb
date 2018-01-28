require 'rails_helper'

RSpec.describe "coursenames/show", :type => :view do
  before(:each) do
    @coursename = assign(:coursename, Coursename.create!(
      :name => "Name",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
  end
end
