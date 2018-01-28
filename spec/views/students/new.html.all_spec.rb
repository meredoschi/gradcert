require 'rails_helper'

RSpec.describe "students/new", type: :view do
  before(:each) do
    assign(:student, Student.new(
      :contact_id => 1,
      :profession_id => 1,
      :council_id => 1
    ))
  end

  it "renders new student form" do
    render

    assert_select "form[action=?][method=?]", students_path, "post" do

      assert_select "input#student_contact_id[name=?]", "student[contact_id]"

      assert_select "input#student_profession_id[name=?]", "student[profession_id]"

      assert_select "input#student_council_id[name=?]", "student[council_id]"
    end
  end
end
