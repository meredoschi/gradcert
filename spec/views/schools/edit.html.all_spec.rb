require 'rails_helper'

RSpec.describe "schools/edit", type: :view do
  before(:each) do
    @school = assign(:school, School.create!(
      :name => "MyString",
      :abbreviation => "MyString",
      :ministrycode => 1,
      :academiccategory_id => 1,
      :public => false
    ))
  end

  it "renders the edit school form" do
    render

    assert_select "form[action=?][method=?]", school_path(@school), "post" do

      assert_select "input#school_name[name=?]", "school[name]"

      assert_select "input#school_abbreviation[name=?]", "school[abbreviation]"

      assert_select "input#school_ministrycode[name=?]", "school[ministrycode]"

      assert_select "input#school_academiccategory_id[name=?]", "school[academiccategory_id]"

      assert_select "input#school_public[name=?]", "school[public]"
    end
  end
end
