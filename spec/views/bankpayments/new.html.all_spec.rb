require 'rails_helper'

RSpec.describe "bankpayments/new", type: :view do
  before(:each) do
    assign(:bankpayment, Bankpayment.new(
      :payroll_id => 1,
      :comment => "MyString",
      :sent => false
    ))
  end

  it "renders new bankpayment form" do
    render

    assert_select "form[action=?][method=?]", bankpayments_path, "post" do

      assert_select "input#bankpayment_payroll_id[name=?]", "bankpayment[payroll_id]"

      assert_select "input#bankpayment_comment[name=?]", "bankpayment[comment]"

      assert_select "input#bankpayment_sent[name=?]", "bankpayment[sent]"
    end
  end
end
