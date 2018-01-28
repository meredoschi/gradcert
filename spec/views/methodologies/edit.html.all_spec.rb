require 'rails_helper'

RSpec.describe "methodologies/edit", :type => :view do
  before(:each) do
    @methodology = assign(:methodology, Methodology.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit methodology form" do
    render

    assert_select "form[action=?][method=?]", methodology_path(@methodology), "post" do

      assert_select "input#methodology_name[name=?]", "methodology[name]"
    end
  end
end
