require 'rails_helper'

RSpec.describe "institutiontypes/new", :type => :view do
  before(:each) do
    assign(:institutiontype, Institutiontype.new(
      :name => "MyString"
    ))
  end

  it "renders new institutiontype form" do
    render

    assert_select "form[action=?][method=?]", institutiontypes_path, "post" do

      assert_select "input#institutiontype_name[name=?]", "institutiontype[name]"
    end
  end
end
