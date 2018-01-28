require 'rails_helper'

RSpec.describe "scholarships/new", type: :view do
  before(:each) do
    assign(:scholarship, Scholarship.new(
      :amount => 1,
      :start => ""
    ))
  end

  it "renders new scholarship form" do
    render

    assert_select "form[action=?][method=?]", scholarships_path, "post" do

      assert_select "input#scholarship_amount[name=?]", "scholarship[amount]"

      assert_select "input#scholarship_start[name=?]", "scholarship[start]"
    end
  end
end
