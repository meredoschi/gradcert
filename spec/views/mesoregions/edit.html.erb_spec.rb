require 'rails_helper'

RSpec.describe "mesoregions/edit", :type => :view do
  before(:each) do
    @mesoregion = assign(:mesoregion, Mesoregion.create!(
      :name => "MyString",
      :brstate_id => 1
    ))
  end

  it "renders the edit mesoregion form" do
    render

    assert_select "form[action=?][method=?]", mesoregion_path(@mesoregion), "post" do

      assert_select "input#mesoregion_name[name=?]", "mesoregion[name]"

      assert_select "input#mesoregion_brstate_id[name=?]", "mesoregion[brstate_id]"
    end
  end
end
