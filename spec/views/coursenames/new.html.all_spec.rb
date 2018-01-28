require 'rails_helper'

RSpec.describe "coursenames/new", :type => :view do
  before(:each) do
    assign(:coursename, Coursename.new(
      :name => "MyString",
      :active => false
    ))
  end

  it "renders new coursename form" do
    render

    assert_select "form[action=?][method=?]", coursenames_path, "post" do

      assert_select "input#coursename_name[name=?]", "coursename[name]"

      assert_select "input#coursename_active[name=?]", "coursename[active]"
    end
  end
end
