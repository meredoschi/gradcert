require 'rails_helper'

RSpec.describe "registrations/edit", type: :view do
  before(:each) do
    @registration = assign(:registration, Registration.create!(
      :student_id => 1,
      :schoolyear_id => 1
    ))
  end

  it "renders the edit registration form" do
    render

    assert_select "form[action=?][method=?]", registration_path(@registration), "post" do

      assert_select "input#registration_student_id[name=?]", "registration[student_id]"

      assert_select "input#registration_schoolyear_id[name=?]", "registration[schoolyear_id]"
    end
  end
end
