require 'rails_helper'

RSpec.describe "rosters/index", type: :view do
  before(:each) do
    assign(:rosters, [
      Roster.create!(
        :institution_id => 1,
        :schoolterm_id => 2,
        :authorizedsupervisors => 3
      ),
      Roster.create!(
        :institution_id => 1,
        :schoolterm_id => 2,
        :authorizedsupervisors => 3
      )
    ])
  end

  it "renders a list of rosters" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
