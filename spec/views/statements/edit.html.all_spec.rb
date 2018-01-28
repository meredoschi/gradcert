require 'rails_helper'

RSpec.describe "statements/edit", type: :view do
  before(:each) do
    @statement = assign(:statement, Statement.create!(
      :registration_id => 1,
      :payroll_id => 1,
      :grossamount_cents => 1,
      :incometax_cents => 1,
      :socialsecurity_cents => 1,
      :childsupport_cents => 1,
      :netamount_cents => 1
    ))
  end

  it "renders the edit statement form" do
    render

    assert_select "form[action=?][method=?]", statement_path(@statement), "post" do

      assert_select "input#statement_registration_id[name=?]", "statement[registration_id]"

      assert_select "input#statement_payroll_id[name=?]", "statement[payroll_id]"

      assert_select "input#statement_grossamount_cents[name=?]", "statement[grossamount_cents]"

      assert_select "input#statement_incometax_cents[name=?]", "statement[incometax_cents]"

      assert_select "input#statement_socialsecurity_cents[name=?]", "statement[socialsecurity_cents]"

      assert_select "input#statement_childsupport_cents[name=?]", "statement[childsupport_cents]"

      assert_select "input#statement_netamount_cents[name=?]", "statement[netamount_cents]"
    end
  end
end
