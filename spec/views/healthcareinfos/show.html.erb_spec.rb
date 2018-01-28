require 'rails_helper'

RSpec.describe "healthcareinfos/show", :type => :view do
  before(:each) do
    @healthcareinfo = assign(:healthcareinfo, Healthcareinfo.create!(
      :institution_id => 1,
      :totalbeds => 2,
      :icubeds => 3,
      :ambulatoryrooms => 4,
      :labs => 5,
      :emergencyroombeds => 6,
      :otherequipment => "Otherequipment"
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
    expect(rendered).to match(/Otherequipment/)
  end
end
