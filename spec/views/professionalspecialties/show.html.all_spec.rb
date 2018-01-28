require 'rails_helper'

RSpec.describe "professionalspecialties/show", type: :view do
  before(:each) do
    @professionalspecialty = assign(:professionalspecialty, Professionalspecialty.create!(
      :name => "Name",
      :fundapcode => "Fundapcode",
      :professionalarea_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Fundapcode/)
    expect(rendered).to match(/1/)
  end
end
