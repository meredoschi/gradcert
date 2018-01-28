require 'rails_helper'

RSpec.describe "regionaloffices/edit", :type => :view do
  before(:each) do
    @regionaloffice = assign(:regionaloffice, Regionaloffice.create!(
      :name => "MyString",
      :references => "",
      :references => "",
      :references => ""
    ))
  end

  it "renders the edit regionaloffice form" do
    render

    assert_select "form[action=?][method=?]", regionaloffice_path(@regionaloffice), "post" do

      assert_select "input#regionaloffice_name[name=?]", "regionaloffice[name]"

      assert_select "input#regionaloffice_references[name=?]", "regionaloffice[references]"

      assert_select "input#regionaloffice_references[name=?]", "regionaloffice[references]"

      assert_select "input#regionaloffice_references[name=?]", "regionaloffice[references]"
    end
  end
end
