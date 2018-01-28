require 'rails_helper'

RSpec.describe "methodologies/show", :type => :view do
  before(:each) do
    @methodology = assign(:methodology, Methodology.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
