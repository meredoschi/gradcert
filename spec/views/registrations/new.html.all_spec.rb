require 'rails_helper'

RSpec.describe "registrations/new", type: :view do
  before(:each) do
    assign(:registration, Registration.new(
      :student_id => 1,
      :schoolyear_id => 1
    ))
  end

  it "renders new registration form" do
    render

    assert_select "form[action=?][method=?]", registrations_path, "post" do

      assert_select "input#registration_student_id[name=?]", "registration[student_id]"

      assert_select "input#registration_schoolyear_id[name=?]", "registration[schoolyear_id]"
    end
  end
end
