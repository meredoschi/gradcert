require 'rails_helper'

RSpec.describe "regionaloffices/new", :type => :view do
  before(:each) do
    assign(:regionaloffice, Regionaloffice.new(
      :name => "MyString",
      :references => "",
      :references => "",
      :references => ""
    ))
  end

  it "renders new regionaloffice form" do
    render

    assert_select "form[action=?][method=?]", regionaloffices_path, "post" do

      assert_select "input#regionaloffice_name[name=?]", "regionaloffice[name]"

      assert_select "input#regionaloffice_references[name=?]", "regionaloffice[references]"

      assert_select "input#regionaloffice_references[name=?]", "regionaloffice[references]"

      assert_select "input#regionaloffice_references[name=?]", "regionaloffice[references]"
    end
  end
end
