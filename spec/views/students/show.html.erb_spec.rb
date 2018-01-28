require 'rails_helper'

RSpec.describe "students/show", :type => :view do
  before(:each) do
    @student = assign(:student, Student.create!(
      :given_name => "Given Name",
      :middle_name => "Middle Name",
      :family_name => "Family Name",
      :grade_point_average => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Given Name/)
    expect(rendered).to match(/Middle Name/)
    expect(rendered).to match(/Family Name/)
    expect(rendered).to match(/9.99/)
  end
end
