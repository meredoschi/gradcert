require 'rails_helper'

RSpec.describe "payrolls/index", type: :view do
  before(:each) do
    assign(:payrolls, [
      Payroll.create!(
        :comment => "Comment"
      ),
      Payroll.create!(
        :comment => "Comment"
      )
    ])
  end

  it "renders a list of payrolls" do
    render
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
  end
end
