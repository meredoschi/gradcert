require 'rails_helper'

RSpec.describe "statements/show", type: :view do
  before(:each) do
    @statement = assign(:statement, Statement.create!(
      :registration_id => 1,
      :payroll_id => 2,
      :grossamount_cents => 3,
      :incometax_cents => 4,
      :socialsecurity_cents => 5,
      :childsupport_cents => 6,
      :netamount_cents => 7
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
  end
end
