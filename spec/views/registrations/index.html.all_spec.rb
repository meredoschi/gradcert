require 'rails_helper'

RSpec.describe "registrations/index", type: :view do
  before(:each) do
    assign(:registrations, [
      Registration.create!(
        :student_id => 1,
        :schoolyear_id => 2
      ),
      Registration.create!(
        :student_id => 1,
        :schoolyear_id => 2
      )
    ])
  end

  it "renders a list of registrations" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
