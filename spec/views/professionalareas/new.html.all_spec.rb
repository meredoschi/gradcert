require 'rails_helper'

RSpec.describe "professionalareas/new", type: :view do
  before(:each) do
    assign(:professionalarea, Professionalarea.new(
      :name => "MyString",
      :previouscode => "MyString"
    ))
  end

  it "renders new professionalarea form" do
    render

    assert_select "form[action=?][method=?]", professionalareas_path, "post" do

      assert_select "input#professionalarea_name[name=?]", "professionalarea[name]"

      assert_select "input#professionalarea_previouscode[name=?]", "professionalarea[previouscode]"
    end
  end
end
