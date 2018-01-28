require 'rails_helper'

RSpec.describe "taxations/index", type: :view do
  before(:each) do
    assign(:taxations, [
      Taxation.create!(
        :socialsecurity => 1,
        :bracket_id => 2
      ),
      Taxation.create!(
        :socialsecurity => 1,
        :bracket_id => 2
      )
    ])
  end

  it "renders a list of taxations" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
