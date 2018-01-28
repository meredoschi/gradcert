require 'rails_helper'

RSpec.describe "scholarships/index", type: :view do
  before(:each) do
    assign(:scholarships, [
      Scholarship.create!(
        :amount => 1,
        :start => ""
      ),
      Scholarship.create!(
        :amount => 1,
        :start => ""
      )
    ])
  end

  it "renders a list of scholarships" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
