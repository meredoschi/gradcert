require 'rails_helper'

RSpec.describe "researchcenters/show", :type => :view do
  before(:each) do
    @researchcenter = assign(:researchcenter, Researchcenter.create!(
      :institution_id => 1,
      :rooms => 2,
      :labs => 3,
      :intlprojectsdone => 4,
      :ongoingintlprojects => 5,
      :domesticprojectsdone => 6,
      :ongoingdomesticprojects => 7
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
  end
end
