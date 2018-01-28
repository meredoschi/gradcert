require 'rails_helper'

RSpec.describe "mesoregions/show", :type => :view do
  before(:each) do
    @mesoregion = assign(:mesoregion, Mesoregion.create!(
      :name => "Name",
      :brstate_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
  end
end
