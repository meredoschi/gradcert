require 'rails_helper'

RSpec.describe "professionalfamilies/new", type: :view do
  before(:each) do
    assign(:professionalfamily, Professionalfamily.new(
      :name => "MyString",
      :subgroup_id => 1,
      :familycode => 1,
      :pap => false,
      :medres => false
    ))
  end

  it "renders new professionalfamily form" do
    render

    assert_select "form[action=?][method=?]", professionalfamilies_path, "post" do

      assert_select "input#professionalfamily_name[name=?]", "professionalfamily[name]"

      assert_select "input#professionalfamily_subgroup_id[name=?]", "professionalfamily[subgroup_id]"

      assert_select "input#professionalfamily_familycode[name=?]", "professionalfamily[familycode]"

      assert_select "input#professionalfamily_pap[name=?]", "professionalfamily[pap]"

      assert_select "input#professionalfamily_medres[name=?]", "professionalfamily[medres]"
    end
  end
end
