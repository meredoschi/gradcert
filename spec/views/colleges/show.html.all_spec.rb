require 'rails_helper'

RSpec.describe "colleges/show", :type => :view do
  before(:each) do
    @college = assign(:college, College.create!(
      :institution_id => 1,
      :area => 2,
      :classrooms => 3,
      :otherrooms => 4,
      :sportscourts => 5,
      :foodplaces => 6,
      :libraries => 7,
      :gradcertificatecourses => 8,
      :previousyeargradcertcompletions => 9
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9/)
  end
end
