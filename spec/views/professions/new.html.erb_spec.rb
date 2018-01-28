require 'rails_helper'

RSpec.describe "professions/new", :type => :view do
  before(:each) do
    assign(:profession, Profession.new(
      :name => "MyString",
      :occupationcode => 1
    ))
  end

  it "renders new profession form" do
    render

    assert_select "form[action=?][method=?]", professions_path, "post" do

      assert_select "input#profession_name[name=?]", "profession[name]"

      assert_select "input#profession_occupationcode[name=?]", "profession[occupationcode]"
    end
  end
end
