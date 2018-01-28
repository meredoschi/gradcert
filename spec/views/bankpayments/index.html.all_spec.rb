require 'rails_helper'

RSpec.describe "bankpayments/index", type: :view do
  before(:each) do
    assign(:bankpayments, [
      Bankpayment.create!(
        :payroll_id => 1,
        :comment => "Comment",
        :sent => false
      ),
      Bankpayment.create!(
        :payroll_id => 1,
        :comment => "Comment",
        :sent => false
      )
    ])
  end

  it "renders a list of bankpayments" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
