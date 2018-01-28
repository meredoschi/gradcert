require 'rails_helper'

RSpec.describe "stateregions/new", :type => :view do
  before(:each) do
    assign(:stateregion, Stateregion.new(
      :name => "MyString",
      :brstate_id => 1
    ))
  end

  it "renders new stateregion form" do
    render

    assert_select "form[action=?][method=?]", stateregions_path, "post" do

      assert_select "input#stateregion_name[name=?]", "stateregion[name]"

      assert_select "input#stateregion_brstate_id[name=?]", "stateregion[brstate_id]"
    end
  end
end
