require 'rails_helper'

RSpec.describe "methodologies/new", :type => :view do
  before(:each) do
    assign(:methodology, Methodology.new(
      :name => "MyString"
    ))
  end

  it "renders new methodology form" do
    render

    assert_select "form[action=?][method=?]", methodologies_path, "post" do

      assert_select "input#methodology_name[name=?]", "methodology[name]"
    end
  end
end
