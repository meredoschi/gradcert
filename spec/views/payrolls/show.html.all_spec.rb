require 'rails_helper'

RSpec.describe "payrolls/show", type: :view do
  before(:each) do
    @payroll = assign(:payroll, Payroll.create!(
      :comment => "Comment"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Comment/)
  end
end
