require 'rails_helper'

RSpec.describe "schooltypes/new", type: :view do
  before(:each) do
    assign(:schooltype, Schooltype.new(
      :name => "MyString"
    ))
  end

  it "renders new schooltype form" do
    render

    assert_select "form[action=?][method=?]", schooltypes_path, "post" do

      assert_select "input#schooltype_name[name=?]", "schooltype[name]"
    end
  end
end
