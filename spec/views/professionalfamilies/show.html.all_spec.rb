require 'rails_helper'

RSpec.describe "professionalfamilies/show", type: :view do
  before(:each) do
    @professionalfamily = assign(:professionalfamily, Professionalfamily.create!(
      :name => "Name",
      :subgroup_id => 1,
      :familycode => 2,
      :pap => false,
      :medres => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
