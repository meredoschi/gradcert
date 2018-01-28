require 'rails_helper'

RSpec.describe "microregions/show", :type => :view do
  before(:each) do
    @microregion = assign(:microregion, Microregion.create!(
      :name => "Name",
      :mesoregion_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
  end
end
