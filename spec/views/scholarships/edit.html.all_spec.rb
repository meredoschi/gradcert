require 'rails_helper'

RSpec.describe "scholarships/edit", type: :view do
  before(:each) do
    @scholarship = assign(:scholarship, Scholarship.create!(
      :amount => 1,
      :start => ""
    ))
  end

  it "renders the edit scholarship form" do
    render

    assert_select "form[action=?][method=?]", scholarship_path(@scholarship), "post" do

      assert_select "input#scholarship_amount[name=?]", "scholarship[amount]"

      assert_select "input#scholarship_start[name=?]", "scholarship[start]"
    end
  end
end
