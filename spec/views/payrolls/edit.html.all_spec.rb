require 'rails_helper'

RSpec.describe "payrolls/edit", type: :view do
  before(:each) do
    @payroll = assign(:payroll, Payroll.create!(
      :comment => "MyString"
    ))
  end

  it "renders the edit payroll form" do
    render

    assert_select "form[action=?][method=?]", payroll_path(@payroll), "post" do

      assert_select "input#payroll_comment[name=?]", "payroll[comment]"
    end
  end
end
