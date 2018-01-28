require 'rails_helper'

RSpec.describe "placesavailables/show", type: :view do
  before(:each) do
    @placesavailable = assign(:placesavailable, Placesavailable.create!(
      :institution_id => 1,
      :schoolterm_id => 2,
      :requested => 3,
      :accredited => 4,
      :authorized => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
  end
end
