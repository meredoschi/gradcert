require 'rails_helper'

RSpec.describe "professionalareas/edit", type: :view do
  before(:each) do
    @professionalarea = assign(:professionalarea, Professionalarea.create!(
      :name => "MyString",
      :previouscode => "MyString"
    ))
  end

  it "renders the edit professionalarea form" do
    render

    assert_select "form[action=?][method=?]", professionalarea_path(@professionalarea), "post" do

      assert_select "input#professionalarea_name[name=?]", "professionalarea[name]"

      assert_select "input#professionalarea_previouscode[name=?]", "professionalarea[previouscode]"
    end
  end
end
