require 'rails_helper'

RSpec.describe "taxations/show", type: :view do
  before(:each) do
    @taxation = assign(:taxation, Taxation.create!(
      :socialsecurity => 1,
      :bracket_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
