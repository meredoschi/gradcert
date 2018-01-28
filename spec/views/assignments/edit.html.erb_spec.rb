require 'rails_helper'

RSpec.describe "assignments/edit", :type => :view do
  before(:each) do
    @assignment = assign(:assignment, Assignment.create!(
      :program_id => 1,
      :supervisor_id => 1,
      :main => false
    ))
  end

  it "renders the edit assignment form" do
    render

    assert_select "form[action=?][method=?]", assignment_path(@assignment), "post" do

      assert_select "input#assignment_program_id[name=?]", "assignment[program_id]"

      assert_select "input#assignment_supervisor_id[name=?]", "assignment[supervisor_id]"

      assert_select "input#assignment_main[name=?]", "assignment[main]"
    end
  end
end
