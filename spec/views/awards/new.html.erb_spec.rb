require 'rails_helper'

RSpec.describe "awards/new", :type => :view do
  before(:each) do
    assign(:award, Award.new(
      :name => "MyString",
      :year => 1,
      :student_id => 1
    ))
  end

  it "renders new award form" do
    render

    assert_select "form[action=?][method=?]", awards_path, "post" do

      assert_select "input#award_name[name=?]", "award[name]"

      assert_select "input#award_year[name=?]", "award[year]"

      assert_select "input#award_student_id[name=?]", "award[student_id]"
    end
  end
end
