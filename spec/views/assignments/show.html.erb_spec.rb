require 'rails_helper'

RSpec.describe "assignments/show", :type => :view do
  before(:each) do
    @assignment = assign(:assignment, Assignment.create!(
      :program_id => 1,
      :supervisor_id => 2,
      :main => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
  end
end
