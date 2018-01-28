require 'rails_helper'

RSpec.describe "bankpayments/edit", type: :view do
  before(:each) do
    @bankpayment = assign(:bankpayment, Bankpayment.create!(
      :payroll_id => 1,
      :comment => "MyString",
      :sent => false
    ))
  end

  it "renders the edit bankpayment form" do
    render

    assert_select "form[action=?][method=?]", bankpayment_path(@bankpayment), "post" do

      assert_select "input#bankpayment_payroll_id[name=?]", "bankpayment[payroll_id]"

      assert_select "input#bankpayment_comment[name=?]", "bankpayment[comment]"

      assert_select "input#bankpayment_sent[name=?]", "bankpayment[sent]"
    end
  end
end
