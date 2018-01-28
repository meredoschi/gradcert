require 'rails_helper'

RSpec.describe "schooltypes/edit", type: :view do
  before(:each) do
    @schooltype = assign(:schooltype, Schooltype.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit schooltype form" do
    render

    assert_select "form[action=?][method=?]", schooltype_path(@schooltype), "post" do

      assert_select "input#schooltype_name[name=?]", "schooltype[name]"
    end
  end
end
