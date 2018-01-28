require 'rails_helper'

RSpec.describe "assignments/new", :type => :view do
  before(:each) do
    assign(:assignment, Assignment.new(
      :program_id => 1,
      :supervisor_id => 1,
      :main => false
    ))
  end

  it "renders new assignment form" do
    render

    assert_select "form[action=?][method=?]", assignments_path, "post" do

      assert_select "input#assignment_program_id[name=?]", "assignment[program_id]"

      assert_select "input#assignment_supervisor_id[name=?]", "assignment[supervisor_id]"

      assert_select "input#assignment_main[name=?]", "assignment[main]"
    end
  end
end
