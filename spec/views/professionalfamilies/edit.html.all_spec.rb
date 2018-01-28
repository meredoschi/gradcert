require 'rails_helper'

RSpec.describe "professionalfamilies/edit", type: :view do
  before(:each) do
    @professionalfamily = assign(:professionalfamily, Professionalfamily.create!(
      :name => "MyString",
      :subgroup_id => 1,
      :familycode => 1,
      :pap => false,
      :medres => false
    ))
  end

  it "renders the edit professionalfamily form" do
    render

    assert_select "form[action=?][method=?]", professionalfamily_path(@professionalfamily), "post" do

      assert_select "input#professionalfamily_name[name=?]", "professionalfamily[name]"

      assert_select "input#professionalfamily_subgroup_id[name=?]", "professionalfamily[subgroup_id]"

      assert_select "input#professionalfamily_familycode[name=?]", "professionalfamily[familycode]"

      assert_select "input#professionalfamily_pap[name=?]", "professionalfamily[pap]"

      assert_select "input#professionalfamily_medres[name=?]", "professionalfamily[medres]"
    end
  end
end
