require 'rails_helper'

RSpec.describe "rosters/new", type: :view do
  before(:each) do
    assign(:roster, Roster.new(
      :institution_id => 1,
      :schoolterm_id => 1,
      :authorizedsupervisors => 1
    ))
  end

  it "renders new roster form" do
    render

    assert_select "form[action=?][method=?]", rosters_path, "post" do

      assert_select "input#roster_institution_id[name=?]", "roster[institution_id]"

      assert_select "input#roster_schoolterm_id[name=?]", "roster[schoolterm_id]"

      assert_select "input#roster_authorizedsupervisors[name=?]", "roster[authorizedsupervisors]"
    end
  end
end
