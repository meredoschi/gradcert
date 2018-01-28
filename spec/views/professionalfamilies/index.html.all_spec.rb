require 'rails_helper'

RSpec.describe "professionalfamilies/index", type: :view do
  before(:each) do
    assign(:professionalfamilies, [
      Professionalfamily.create!(
        :name => "Name",
        :subgroup_id => 1,
        :familycode => 2,
        :pap => false,
        :medres => false
      ),
      Professionalfamily.create!(
        :name => "Name",
        :subgroup_id => 1,
        :familycode => 2,
        :pap => false,
        :medres => false
      )
    ])
  end

  it "renders a list of professionalfamilies" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
