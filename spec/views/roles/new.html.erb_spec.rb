require 'rails_helper'

RSpec.describe "roles/new", :type => :view do
  before(:each) do
    assign(:role, Role.new(
      :name => "MyString",
      :management => false,
      :teaching => false,
      :clerical => false
    ))
  end

  it "renders new role form" do
    render

    assert_select "form[action=?][method=?]", roles_path, "post" do

      assert_select "input#role_name[name=?]", "role[name]"

      assert_select "input#role_management[name=?]", "role[management]"

      assert_select "input#role_teaching[name=?]", "role[teaching]"

      assert_select "input#role_clerical[name=?]", "role[clerical]"
    end
  end
end
