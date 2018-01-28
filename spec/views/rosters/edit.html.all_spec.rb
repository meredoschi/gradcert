require 'rails_helper'

RSpec.describe "rosters/edit", type: :view do
  before(:each) do
    @roster = assign(:roster, Roster.create!(
      :institution_id => 1,
      :schoolterm_id => 1,
      :authorizedsupervisors => 1
    ))
  end

  it "renders the edit roster form" do
    render

    assert_select "form[action=?][method=?]", roster_path(@roster), "post" do

      assert_select "input#roster_institution_id[name=?]", "roster[institution_id]"

      assert_select "input#roster_schoolterm_id[name=?]", "roster[schoolterm_id]"

      assert_select "input#roster_authorizedsupervisors[name=?]", "roster[authorizedsupervisors]"
    end
  end
end
