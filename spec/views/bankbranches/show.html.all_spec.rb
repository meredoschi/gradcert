require 'rails_helper'

RSpec.describe "bankbranches/show", type: :view do
  before(:each) do
    @bankbranch = assign(:bankbranch, Bankbranch.create!(
      :num => 1,
      :name => "Name",
      :formername => "Formername",
      :municipality_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Formername/)
    expect(rendered).to match(/2/)
  end
end
