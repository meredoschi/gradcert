require 'rails_helper'

RSpec.describe "annotations/new", type: :view do
  before(:each) do
    assign(:annotation, Annotation.new(
      :registration_id => 1,
      :payroll_id => 1,
      :absences => 1,
      :discount => 1,
      :skip => false,
      :comment => "MyString"
    ))
  end

  it "renders new annotation form" do
    render

    assert_select "form[action=?][method=?]", annotations_path, "post" do

      assert_select "input#annotation_registration_id[name=?]", "annotation[registration_id]"

      assert_select "input#annotation_payroll_id[name=?]", "annotation[payroll_id]"

      assert_select "input#annotation_absences[name=?]", "annotation[absences]"

      assert_select "input#annotation_discount[name=?]", "annotation[discount]"

      assert_select "input#annotation_skip[name=?]", "annotation[skip]"

      assert_select "input#annotation_comment[name=?]", "annotation[comment]"
    end
  end
end
