require 'rails_helper'

RSpec.describe "statements/index", type: :view do
  before(:each) do
    assign(:statements, [
      Statement.create!(
        :registration_id => 1,
        :payroll_id => 2,
        :grossamount_cents => 3,
        :incometax_cents => 4,
        :socialsecurity_cents => 5,
        :childsupport_cents => 6,
        :netamount_cents => 7
      ),
      Statement.create!(
        :registration_id => 1,
        :payroll_id => 2,
        :grossamount_cents => 3,
        :incometax_cents => 4,
        :socialsecurity_cents => 5,
        :childsupport_cents => 6,
        :netamount_cents => 7
      )
    ])
  end

  it "renders a list of statements" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
  end
end
