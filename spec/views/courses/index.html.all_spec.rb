require 'rails_helper'

RSpec.describe "courses/index", :type => :view do
  before(:each) do
    assign(:courses, [
      Course.create!(
        :coursename_id => 1,
        :profession_id => 2,
        :practical => false,
        :core => false,
        :professionalrequirement => false,
        :contact_id => 3,
        :methodology_id => 4,
        :address_id => 5,
        :workload => 6,
        :syllabus => "Syllabus"
      ),
      Course.create!(
        :coursename_id => 1,
        :profession_id => 2,
        :practical => false,
        :core => false,
        :professionalrequirement => false,
        :contact_id => 3,
        :methodology_id => 4,
        :address_id => 5,
        :workload => 6,
        :syllabus => "Syllabus"
      )
    ])
  end

  it "renders a list of courses" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => "Syllabus".to_s, :count => 2
  end
end
