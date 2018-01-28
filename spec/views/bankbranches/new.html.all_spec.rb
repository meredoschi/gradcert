require 'rails_helper'

RSpec.describe "bankbranches/new", type: :view do
  before(:each) do
    assign(:bankbranch, Bankbranch.new(
      :num => 1,
      :name => "MyString",
      :formername => "MyString",
      :municipality_id => 1
    ))
  end

  it "renders new bankbranch form" do
    render

    assert_select "form[action=?][method=?]", bankbranches_path, "post" do

      assert_select "input#bankbranch_num[name=?]", "bankbranch[num]"

      assert_select "input#bankbranch_name[name=?]", "bankbranch[name]"

      assert_select "input#bankbranch_formername[name=?]", "bankbranch[formername]"

      assert_select "input#bankbranch_municipality_id[name=?]", "bankbranch[municipality_id]"
    end
  end
end
