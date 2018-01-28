require 'rails_helper'

RSpec.describe "gifts/show", :type => :view do
  before(:each) do
    @gift = assign(:gift, Gift.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
