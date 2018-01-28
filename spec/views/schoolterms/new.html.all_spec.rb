require 'rails_helper'

RSpec.describe "schoolterms/new", type: :view do
  before(:each) do
    assign(:schoolterm, Schoolterm.new(
      :duration => 1,
      :active => false,
      :pap => false,
      :medres => false
    ))
  end

  it "renders new schoolterm form" do
    render

    assert_select "form[action=?][method=?]", schoolterms_path, "post" do

      assert_select "input#schoolterm_duration[name=?]", "schoolterm[duration]"

      assert_select "input#schoolterm_active[name=?]", "schoolterm[active]"

      assert_select "input#schoolterm_pap[name=?]", "schoolterm[pap]"

      assert_select "input#schoolterm_medres[name=?]", "schoolterm[medres]"
    end
  end
end
