require 'rails_helper'

RSpec.describe "professions/edit", :type => :view do
  before(:each) do
    @profession = assign(:profession, Profession.create!(
      :name => "MyString",
      :occupationcode => 1
    ))
  end

  it "renders the edit profession form" do
    render

    assert_select "form[action=?][method=?]", profession_path(@profession), "post" do

      assert_select "input#profession_name[name=?]", "profession[name]"

      assert_select "input#profession_occupationcode[name=?]", "profession[occupationcode]"
    end
  end
end
