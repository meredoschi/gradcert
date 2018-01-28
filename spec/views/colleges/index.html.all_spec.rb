require 'rails_helper'

RSpec.describe "colleges/index", :type => :view do
  before(:each) do
    assign(:colleges, [
      College.create!(
        :institution_id => 1,
        :area => 2,
        :classrooms => 3,
        :otherrooms => 4,
        :sportscourts => 5,
        :foodplaces => 6,
        :libraries => 7,
        :gradcertificatecourses => 8,
        :previousyeargradcertcompletions => 9
      ),
      College.create!(
        :institution_id => 1,
        :area => 2,
        :classrooms => 3,
        :otherrooms => 4,
        :sportscourts => 5,
        :foodplaces => 6,
        :libraries => 7,
        :gradcertificatecourses => 8,
        :previousyeargradcertcompletions => 9
      )
    ])
  end

  it "renders a list of colleges" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
  end
end
