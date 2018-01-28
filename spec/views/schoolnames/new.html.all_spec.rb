require 'rails_helper'

RSpec.describe "schoolnames/new", type: :view do
  before(:each) do
    assign(:schoolname, Schoolname.new(
      :name => "MyString",
      :previousname => "MyString",
      :active => false
    ))
  end

  it "renders new schoolname form" do
    render

    assert_select "form[action=?][method=?]", schoolnames_path, "post" do

      assert_select "input#schoolname_name[name=?]", "schoolname[name]"

      assert_select "input#schoolname_previousname[name=?]", "schoolname[previousname]"

      assert_select "input#schoolname_active[name=?]", "schoolname[active]"
    end
  end
end
