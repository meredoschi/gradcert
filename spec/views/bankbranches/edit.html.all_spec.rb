require 'rails_helper'

RSpec.describe "bankbranches/edit", type: :view do
  before(:each) do
    @bankbranch = assign(:bankbranch, Bankbranch.create!(
      :num => 1,
      :name => "MyString",
      :formername => "MyString",
      :municipality_id => 1
    ))
  end

  it "renders the edit bankbranch form" do
    render

    assert_select "form[action=?][method=?]", bankbranch_path(@bankbranch), "post" do

      assert_select "input#bankbranch_num[name=?]", "bankbranch[num]"

      assert_select "input#bankbranch_name[name=?]", "bankbranch[name]"

      assert_select "input#bankbranch_formername[name=?]", "bankbranch[formername]"

      assert_select "input#bankbranch_municipality_id[name=?]", "bankbranch[municipality_id]"
    end
  end
end
