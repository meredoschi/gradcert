require 'rails_helper'

RSpec.describe "councils/show", type: :view do
  before(:each) do
    @council = assign(:council, Council.create!(
      :name => "Name",
      :address_id => 1,
      :phone_id => 2,
      :webinfo_id => 3,
      :state_id => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
