require 'rails_helper'

RSpec.describe "programnames/new", :type => :view do
  before(:each) do
    assign(:programname, Programname.new(
      :name => "MyString"
    ))
  end

  it "renders new programname form" do
    render

    assert_select "form[action=?][method=?]", programnames_path, "post" do

      assert_select "input#programname_name[name=?]", "programname[name]"
    end
  end
end
