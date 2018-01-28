require 'rails_helper'

RSpec.describe "colleges/edit", :type => :view do
  before(:each) do
    @college = assign(:college, College.create!(
      :institution_id => 1,
      :area => 1,
      :classrooms => 1,
      :otherrooms => 1,
      :sportscourts => 1,
      :foodplaces => 1,
      :libraries => 1,
      :gradcertificatecourses => 1,
      :previousyeargradcertcompletions => 1
    ))
  end

  it "renders the edit college form" do
    render

    assert_select "form[action=?][method=?]", college_path(@college), "post" do

      assert_select "input#college_institution_id[name=?]", "college[institution_id]"

      assert_select "input#college_area[name=?]", "college[area]"

      assert_select "input#college_classrooms[name=?]", "college[classrooms]"

      assert_select "input#college_otherrooms[name=?]", "college[otherrooms]"

      assert_select "input#college_sportscourts[name=?]", "college[sportscourts]"

      assert_select "input#college_foodplaces[name=?]", "college[foodplaces]"

      assert_select "input#college_libraries[name=?]", "college[libraries]"

      assert_select "input#college_gradcertificatecourses[name=?]", "college[gradcertificatecourses]"

      assert_select "input#college_previousyeargradcertcompletions[name=?]", "college[previousyeargradcertcompletions]"
    end
  end
end
