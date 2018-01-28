require 'rails_helper'

RSpec.describe "degreetypes/new", :type => :view do
  before(:each) do
    assign(:degreetype, Degreetype.new(
      :name => "MyString"
    ))
  end

  it "renders new degreetype form" do
    render

    assert_select "form[action=?][method=?]", degreetypes_path, "post" do

      assert_select "input#degreetype_name[name=?]", "degreetype[name]"
    end
  end
end
