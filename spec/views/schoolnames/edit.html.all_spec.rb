require 'rails_helper'

RSpec.describe "schoolnames/edit", type: :view do
  before(:each) do
    @schoolname = assign(:schoolname, Schoolname.create!(
      :name => "MyString",
      :previousname => "MyString",
      :active => false
    ))
  end

  it "renders the edit schoolname form" do
    render

    assert_select "form[action=?][method=?]", schoolname_path(@schoolname), "post" do

      assert_select "input#schoolname_name[name=?]", "schoolname[name]"

      assert_select "input#schoolname_previousname[name=?]", "schoolname[previousname]"

      assert_select "input#schoolname_active[name=?]", "schoolname[active]"
    end
  end
end
