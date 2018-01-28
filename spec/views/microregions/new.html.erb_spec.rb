require 'rails_helper'

RSpec.describe "microregions/new", :type => :view do
  before(:each) do
    assign(:microregion, Microregion.new(
      :name => "MyString",
      :mesoregion_id => 1
    ))
  end

  it "renders new microregion form" do
    render

    assert_select "form[action=?][method=?]", microregions_path, "post" do

      assert_select "input#microregion_name[name=?]", "microregion[name]"

      assert_select "input#microregion_mesoregion_id[name=?]", "microregion[mesoregion_id]"
    end
  end
end
