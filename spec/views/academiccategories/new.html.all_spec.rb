require 'rails_helper'

RSpec.describe "academiccategories/new", type: :view do
  before(:each) do
    assign(:academiccategory, Academiccategory.new(
      :name => "MyString"
    ))
  end

  it "renders new academiccategory form" do
    render

    assert_select "form[action=?][method=?]", academiccategories_path, "post" do

      assert_select "input#academiccategory_name[name=?]", "academiccategory[name]"
    end
  end
end
