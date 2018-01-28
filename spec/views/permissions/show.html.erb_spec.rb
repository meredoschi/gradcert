require 'rails_helper'

RSpec.describe "permissions/show", :type => :view do
  before(:each) do
    @permission = assign(:permission, Permission.create!(
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
  end
end
