require 'rails_helper'

RSpec.describe "taxations/new", type: :view do
  before(:each) do
    assign(:taxation, Taxation.new(
      :socialsecurity => 1,
      :bracket_id => 1
    ))
  end

  it "renders new taxation form" do
    render

    assert_select "form[action=?][method=?]", taxations_path, "post" do

      assert_select "input#taxation_socialsecurity[name=?]", "taxation[socialsecurity]"

      assert_select "input#taxation_bracket_id[name=?]", "taxation[bracket_id]"
    end
  end
end
