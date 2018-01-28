require 'rails_helper'

RSpec.describe "students/edit", type: :view do
  before(:each) do
    @student = assign(:student, Student.create!(
      :contact_id => 1,
      :profession_id => 1,
      :council_id => 1
    ))
  end

  it "renders the edit student form" do
    render

    assert_select "form[action=?][method=?]", student_path(@student), "post" do

      assert_select "input#student_contact_id[name=?]", "student[contact_id]"

      assert_select "input#student_profession_id[name=?]", "student[profession_id]"

      assert_select "input#student_council_id[name=?]", "student[council_id]"
    end
  end
end
