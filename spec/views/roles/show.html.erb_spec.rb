require 'rails_helper'

RSpec.describe "roles/show", :type => :view do
  before(:each) do
    @role = assign(:role, Role.create!(
      :name => "Name",
      :management => false,
      :teaching => false,
      :clerical => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
