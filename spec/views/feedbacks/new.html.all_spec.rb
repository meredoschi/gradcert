require 'rails_helper'

RSpec.describe "feedbacks/new", type: :view do
  before(:each) do
    assign(:feedback, Feedback.new(
      :registration_id => 1,
      :bankpayment_id => 1,
      :returned => false,
      :missed => false
    ))
  end

  it "renders new feedback form" do
    render

    assert_select "form[action=?][method=?]", feedbacks_path, "post" do

      assert_select "input#feedback_registration_id[name=?]", "feedback[registration_id]"

      assert_select "input#feedback_bankpayment_id[name=?]", "feedback[bankpayment_id]"

      assert_select "input#feedback_returned[name=?]", "feedback[returned]"

      assert_select "input#feedback_missed[name=?]", "feedback[missed]"
    end
  end
end
