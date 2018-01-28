require 'rails_helper'

RSpec.describe "degreetypes/show", :type => :view do
  before(:each) do
    @degreetype = assign(:degreetype, Degreetype.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
