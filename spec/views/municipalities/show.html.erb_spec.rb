require 'rails_helper'

RSpec.describe "municipalities/show", :type => :view do
  before(:each) do
    @municipality = assign(:municipality, Municipality.create!(
      :name => "Name",
      :microregion_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
  end
end
