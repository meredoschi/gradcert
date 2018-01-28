require 'rails_helper'

RSpec.describe "courses/show", :type => :view do
  before(:each) do
    @course = assign(:course, Course.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/Syllabus/)
  end
end
