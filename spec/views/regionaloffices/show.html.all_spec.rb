require 'rails_helper'

RSpec.describe "regionaloffices/show", :type => :view do
  before(:each) do
    @regionaloffice = assign(:regionaloffice, Regionaloffice.create!(
      :name => "Name",
      :references => "",
      :references => "",
      :references => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
