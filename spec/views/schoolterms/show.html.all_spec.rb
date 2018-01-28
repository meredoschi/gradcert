require 'rails_helper'

RSpec.describe "schoolterms/show", type: :view do
  before(:each) do
    @schoolterm = assign(:schoolterm, Schoolterm.create!(
      :duration => 1,
      :active => false,
      :pap => false,
      :medres => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
