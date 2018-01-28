require 'rails_helper'

RSpec.describe "microregions/edit", :type => :view do
  before(:each) do
    @microregion = assign(:microregion, Microregion.create!(
      :name => "MyString",
      :mesoregion_id => 1
    ))
  end

  it "renders the edit microregion form" do
    render

    assert_select "form[action=?][method=?]", microregion_path(@microregion), "post" do

      assert_select "input#microregion_name[name=?]", "microregion[name]"

      assert_select "input#microregion_mesoregion_id[name=?]", "microregion[mesoregion_id]"
    end
  end
end
