require 'rails_helper'

RSpec.describe "bankpayments/show", type: :view do
  before(:each) do
    @bankpayment = assign(:bankpayment, Bankpayment.create!(
      :payroll_id => 1,
      :comment => "Comment",
      :sent => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Comment/)
    expect(rendered).to match(/false/)
  end
end
