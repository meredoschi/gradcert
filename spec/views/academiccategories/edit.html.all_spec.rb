require 'rails_helper'

RSpec.describe "academiccategories/edit", type: :view do
  before(:each) do
    @academiccategory = assign(:academiccategory, Academiccategory.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit academiccategory form" do
    render

    assert_select "form[action=?][method=?]", academiccategory_path(@academiccategory), "post" do

      assert_select "input#academiccategory_name[name=?]", "academiccategory[name]"
    end
  end
end
