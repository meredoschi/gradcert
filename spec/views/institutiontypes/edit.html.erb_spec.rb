require 'rails_helper'

RSpec.describe "institutiontypes/edit", :type => :view do
  before(:each) do
    @institutiontype = assign(:institutiontype, Institutiontype.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit institutiontype form" do
    render

    assert_select "form[action=?][method=?]", institutiontype_path(@institutiontype), "post" do

      assert_select "input#institutiontype_name[name=?]", "institutiontype[name]"
    end
  end
end
