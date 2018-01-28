require 'rails_helper'

RSpec.describe "statements/new", type: :view do
  before(:each) do
    assign(:statement, Statement.new(
      :registration_id => 1,
      :payroll_id => 1,
      :grossamount_cents => 1,
      :incometax_cents => 1,
      :socialsecurity_cents => 1,
      :childsupport_cents => 1,
      :netamount_cents => 1
    ))
  end

  it "renders new statement form" do
    render

    assert_select "form[action=?][method=?]", statements_path, "post" do

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
