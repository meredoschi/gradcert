require 'rails_helper'

RSpec.describe "stateregions/edit", :type => :view do
  before(:each) do
    @stateregion = assign(:stateregion, Stateregion.create!(
      :name => "MyString",
      :brstate_id => 1
    ))
  end

  it "renders the edit stateregion form" do
    render

    assert_select "form[action=?][method=?]", stateregion_path(@stateregion), "post" do

      assert_select "input#stateregion_name[name=?]", "stateregion[name]"

      assert_select "input#stateregion_brstate_id[name=?]", "stateregion[brstate_id]"
    end
  end
end
