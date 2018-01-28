require 'rails_helper'

RSpec.describe "taxations/edit", type: :view do
  before(:each) do
    @taxation = assign(:taxation, Taxation.create!(
      :socialsecurity => 1,
      :bracket_id => 1
    ))
  end

  it "renders the edit taxation form" do
    render

    assert_select "form[action=?][method=?]", taxation_path(@taxation), "post" do

      assert_select "input#taxation_socialsecurity[name=?]", "taxation[socialsecurity]"

      assert_select "input#taxation_bracket_id[name=?]", "taxation[bracket_id]"
    end
  end
end
