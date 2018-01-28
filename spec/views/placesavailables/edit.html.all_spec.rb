require 'rails_helper'

RSpec.describe "placesavailables/edit", type: :view do
  before(:each) do
    @placesavailable = assign(:placesavailable, Placesavailable.create!(
      :institution_id => 1,
      :schoolterm_id => 1,
      :requested => 1,
      :accredited => 1,
      :authorized => 1
    ))
  end

  it "renders the edit placesavailable form" do
    render

    assert_select "form[action=?][method=?]", placesavailable_path(@placesavailable), "post" do

      assert_select "input#placesavailable_institution_id[name=?]", "placesavailable[institution_id]"

      assert_select "input#placesavailable_schoolterm_id[name=?]", "placesavailable[schoolterm_id]"

      assert_select "input#placesavailable_requested[name=?]", "placesavailable[requested]"

      assert_select "input#placesavailable_accredited[name=?]", "placesavailable[accredited]"

      assert_select "input#placesavailable_authorized[name=?]", "placesavailable[authorized]"
    end
  end
end
