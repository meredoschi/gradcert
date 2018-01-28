require 'rails_helper'

RSpec.describe "schools/new", type: :view do
  before(:each) do
    assign(:school, School.new(
      :name => "MyString",
      :abbreviation => "MyString",
      :ministrycode => 1,
      :academiccategory_id => 1,
      :public => false
    ))
  end

  it "renders new school form" do
    render

    assert_select "form[action=?][method=?]", schools_path, "post" do

      assert_select "input#school_name[name=?]", "school[name]"

      assert_select "input#school_abbreviation[name=?]", "school[abbreviation]"

      assert_select "input#school_ministrycode[name=?]", "school[ministrycode]"

      assert_select "input#school_academiccategory_id[name=?]", "school[academiccategory_id]"

      assert_select "input#school_public[name=?]", "school[public]"
    end
  end
end
