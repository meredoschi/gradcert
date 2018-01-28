require 'rails_helper'

RSpec.describe "councils/new", type: :view do
  before(:each) do
    assign(:council, Council.new(
      :name => "MyString",
      :address_id => 1,
      :phone_id => 1,
      :webinfo_id => 1,
      :state_id => 1
    ))
  end

  it "renders new council form" do
    render

    assert_select "form[action=?][method=?]", councils_path, "post" do

      assert_select "input#council_name[name=?]", "council[name]"

      assert_select "input#council_address_id[name=?]", "council[address_id]"

      assert_select "input#council_phone_id[name=?]", "council[phone_id]"

      assert_select "input#council_webinfo_id[name=?]", "council[webinfo_id]"

      assert_select "input#council_state_id[name=?]", "council[state_id]"
    end
  end
end
