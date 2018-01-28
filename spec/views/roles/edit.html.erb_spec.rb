require 'rails_helper'

RSpec.describe "roles/edit", :type => :view do
  before(:each) do
    @role = assign(:role, Role.create!(
      :name => "MyString",
      :management => false,
      :teaching => false,
      :clerical => false
    ))
  end

  it "renders the edit role form" do
    render

    assert_select "form[action=?][method=?]", role_path(@role), "post" do

      assert_select "input#role_name[name=?]", "role[name]"

      assert_select "input#role_management[name=?]", "role[management]"

      assert_select "input#role_teaching[name=?]", "role[teaching]"

      assert_select "input#role_clerical[name=?]", "role[clerical]"
    end
  end
end
