require 'rails_helper'

RSpec.describe "coursenames/edit", :type => :view do
  before(:each) do
    @coursename = assign(:coursename, Coursename.create!(
      :name => "MyString",
      :active => false
    ))
  end

  it "renders the edit coursename form" do
    render

    assert_select "form[action=?][method=?]", coursename_path(@coursename), "post" do

      assert_select "input#coursename_name[name=?]", "coursename[name]"

      assert_select "input#coursename_active[name=?]", "coursename[active]"
    end
  end
end
