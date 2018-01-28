require 'rails_helper'

RSpec.describe "feedbacks/show", type: :view do
  before(:each) do
    @feedback = assign(:feedback, Feedback.create!(
      :registration_id => 1,
      :bankpayment_id => 2,
      :returned => false,
      :missed => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
