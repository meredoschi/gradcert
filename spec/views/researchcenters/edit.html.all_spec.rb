require 'rails_helper'

RSpec.describe "researchcenters/edit", :type => :view do
  before(:each) do
    @researchcenter = assign(:researchcenter, Researchcenter.create!(
      :institution_id => 1,
      :rooms => 1,
      :labs => 1,
      :intlprojectsdone => 1,
      :ongoingintlprojects => 1,
      :domesticprojectsdone => 1,
      :ongoingdomesticprojects => 1
    ))
  end

  it "renders the edit researchcenter form" do
    render

    assert_select "form[action=?][method=?]", researchcenter_path(@researchcenter), "post" do

      assert_select "input#researchcenter_institution_id[name=?]", "researchcenter[institution_id]"

      assert_select "input#researchcenter_rooms[name=?]", "researchcenter[rooms]"

      assert_select "input#researchcenter_labs[name=?]", "researchcenter[labs]"

      assert_select "input#researchcenter_intlprojectsdone[name=?]", "researchcenter[intlprojectsdone]"

      assert_select "input#researchcenter_ongoingintlprojects[name=?]", "researchcenter[ongoingintlprojects]"

      assert_select "input#researchcenter_domesticprojectsdone[name=?]", "researchcenter[domesticprojectsdone]"

      assert_select "input#researchcenter_ongoingdomesticprojects[name=?]", "researchcenter[ongoingdomesticprojects]"
    end
  end
end
