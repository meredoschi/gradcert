require 'rails_helper'

RSpec.describe "feedbacks/index", type: :view do
  before(:each) do
    assign(:feedbacks, [
      Feedback.create!(
        :registration_id => 1,
        :bankpayment_id => 2,
        :returned => false,
        :missed => false
      ),
      Feedback.create!(
        :registration_id => 1,
        :bankpayment_id => 2,
        :returned => false,
        :missed => false
      )
    ])
  end

  it "renders a list of feedbacks" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
