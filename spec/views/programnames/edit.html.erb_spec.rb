require 'rails_helper'

RSpec.describe "programnames/edit", :type => :view do
  before(:each) do
    @programname = assign(:programname, Programname.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit programname form" do
    render

    assert_select "form[action=?][method=?]", programname_path(@programname), "post" do

      assert_select "input#programname_name[name=?]", "programname[name]"
    end
  end
end
