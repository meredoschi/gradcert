require 'rails_helper'

RSpec.describe "students/index", :type => :view do
  before(:each) do
    assign(:students, [
      Student.create!(
        :given_name => "Given Name",
        :middle_name => "Middle Name",
        :family_name => "Family Name",
        :grade_point_average => "9.99"
      ),
      Student.create!(
        :given_name => "Given Name",
        :middle_name => "Middle Name",
        :family_name => "Family Name",
        :grade_point_average => "9.99"
      )
    ])
  end

  it "renders a list of students" do
    render
    assert_select "tr>td", :text => "Given Name".to_s, :count => 2
    assert_select "tr>td", :text => "Middle Name".to_s, :count => 2
    assert_select "tr>td", :text => "Family Name".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
