require 'rails_helper'

RSpec.describe "students/new", :type => :view do
  before(:each) do
    assign(:student, Student.new(
      :given_name => "MyString",
      :middle_name => "MyString",
      :family_name => "MyString",
      :grade_point_average => "9.99"
    ))
  end

  it "renders new student form" do
    render

    assert_select "form[action=?][method=?]", students_path, "post" do

      assert_select "input#student_given_name[name=?]", "student[given_name]"

      assert_select "input#student_middle_name[name=?]", "student[middle_name]"

      assert_select "input#student_family_name[name=?]", "student[family_name]"

      assert_select "input#student_grade_point_average[name=?]", "student[grade_point_average]"
    end
  end
end
