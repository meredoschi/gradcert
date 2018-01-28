require 'rails_helper'

RSpec.describe "leavetypes/show", type: :view do
  before(:each) do
    @leavetype = assign(:leavetype, Leavetype.create!(
      :name => "Name",
      :paid => false,
      :comment => "Comment"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Comment/)
  end
end
