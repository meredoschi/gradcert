require 'rails_helper'

RSpec.describe "leavetypes/new", type: :view do
  before(:each) do
    assign(:leavetype, Leavetype.new(
      :name => "MyString",
      :paid => false,
      :comment => "MyString"
    ))
  end

  it "renders new leavetype form" do
    render

    assert_select "form[action=?][method=?]", leavetypes_path, "post" do

      assert_select "input#leavetype_name[name=?]", "leavetype[name]"

      assert_select "input#leavetype_paid[name=?]", "leavetype[paid]"

      assert_select "input#leavetype_comment[name=?]", "leavetype[comment]"
    end
  end
end
