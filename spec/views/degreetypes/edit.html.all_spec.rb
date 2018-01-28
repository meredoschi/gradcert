require 'rails_helper'

RSpec.describe "degreetypes/edit", :type => :view do
  before(:each) do
    @degreetype = assign(:degreetype, Degreetype.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit degreetype form" do
    render

    assert_select "form[action=?][method=?]", degreetype_path(@degreetype), "post" do

      assert_select "input#degreetype_name[name=?]", "degreetype[name]"
    end
  end
end
