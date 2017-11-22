require 'rails_helper'

RSpec.describe "things/new", type: :view do
  before(:each) do
    assign(:thing, Thing.new(
      :name => "MyString"
    ))
  end

  it "renders new thing form" do
    render

    assert_select "form[action=?][method=?]", things_path, "post" do

      assert_select "input#thing_name[name=?]", "thing[name]"
    end
  end
end
