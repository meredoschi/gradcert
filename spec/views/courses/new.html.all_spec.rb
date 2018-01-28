require 'rails_helper'

RSpec.describe "courses/new", :type => :view do
  before(:each) do
    assign(:course, Course.new(
      :coursename_id => 1,
      :profession_id => 1,
      :practical => false,
      :core => false,
      :professionalrequirement => false,
      :contact_id => 1,
      :methodology_id => 1,
      :address_id => 1,
      :workload => 1,
      :syllabus => "MyString"
    ))
  end

  it "renders new course form" do
    render

    assert_select "form[action=?][method=?]", courses_path, "post" do

      assert_select "input#course_coursename_id[name=?]", "course[coursename_id]"

      assert_select "input#course_profession_id[name=?]", "course[profession_id]"

      assert_select "input#course_practical[name=?]", "course[practical]"

      assert_select "input#course_core[name=?]", "course[core]"

      assert_select "input#course_professionalrequirement[name=?]", "course[professionalrequirement]"

      assert_select "input#course_contact_id[name=?]", "course[contact_id]"

      assert_select "input#course_methodology_id[name=?]", "course[methodology_id]"

      assert_select "input#course_address_id[name=?]", "course[address_id]"

      assert_select "input#course_workload[name=?]", "course[workload]"

      assert_select "input#course_syllabus[name=?]", "course[syllabus]"
    end
  end
end
