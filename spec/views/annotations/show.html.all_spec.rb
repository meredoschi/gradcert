require 'rails_helper'

RSpec.describe "annotations/show", type: :view do
  before(:each) do
    @annotation = assign(:annotation, Annotation.create!(
      :registration_id => 1,
      :payroll_id => 2,
      :absences => 3,
      :discount => 4,
      :skip => false,
      :comment => "Comment"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Comment/)
  end
end
