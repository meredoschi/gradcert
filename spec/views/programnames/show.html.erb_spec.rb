require 'rails_helper'

RSpec.describe "programnames/show", :type => :view do
  before(:each) do
    @programname = assign(:programname, Programname.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
