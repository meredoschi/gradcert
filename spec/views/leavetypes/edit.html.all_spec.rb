require 'rails_helper'

RSpec.describe "leavetypes/edit", type: :view do
  before(:each) do
    @leavetype = assign(:leavetype, Leavetype.create!(
      :name => "MyString",
      :paid => false,
      :comment => "MyString"
    ))
  end

  it "renders the edit leavetype form" do
    render

    assert_select "form[action=?][method=?]", leavetype_path(@leavetype), "post" do

      assert_select "input#leavetype_name[name=?]", "leavetype[name]"

      assert_select "input#leavetype_paid[name=?]", "leavetype[paid]"

      assert_select "input#leavetype_comment[name=?]", "leavetype[comment]"
    end
  end
end
