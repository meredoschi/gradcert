require 'rails_helper'

RSpec.describe "mesoregions/new", :type => :view do
  before(:each) do
    assign(:mesoregion, Mesoregion.new(
      :name => "MyString",
      :brstate_id => 1
    ))
  end

  it "renders new mesoregion form" do
    render

    assert_select "form[action=?][method=?]", mesoregions_path, "post" do

      assert_select "input#mesoregion_name[name=?]", "mesoregion[name]"

      assert_select "input#mesoregion_brstate_id[name=?]", "mesoregion[brstate_id]"
    end
  end
end
