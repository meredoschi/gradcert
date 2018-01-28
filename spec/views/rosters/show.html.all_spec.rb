require 'rails_helper'

RSpec.describe "rosters/show", type: :view do
  before(:each) do
    @roster = assign(:roster, Roster.create!(
      :institution_id => 1,
      :schoolterm_id => 2,
      :authorizedsupervisors => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
