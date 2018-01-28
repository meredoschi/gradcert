require 'rails_helper'

RSpec.describe "annotations/index", type: :view do
  before(:each) do
    assign(:annotations, [
      Annotation.create!(
        :registration_id => 1,
        :payroll_id => 2,
        :absences => 3,
        :discount => 4,
        :skip => false,
        :comment => "Comment"
      ),
      Annotation.create!(
        :registration_id => 1,
        :payroll_id => 2,
        :absences => 3,
        :discount => 4,
        :skip => false,
        :comment => "Comment"
      )
    ])
  end

  it "renders a list of annotations" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
  end
end
