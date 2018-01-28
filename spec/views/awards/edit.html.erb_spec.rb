require 'rails_helper'

RSpec.describe "awards/edit", :type => :view do
  before(:each) do
    @award = assign(:award, Award.create!(
      :name => "MyString",
      :year => 1,
      :student_id => 1
    ))
  end

  it "renders the edit award form" do
    render

    assert_select "form[action=?][method=?]", award_path(@award), "post" do

      assert_select "input#award_name[name=?]", "award[name]"

      assert_select "input#award_year[name=?]", "award[year]"

      assert_select "input#award_student_id[name=?]", "award[student_id]"
    end
  end
end
