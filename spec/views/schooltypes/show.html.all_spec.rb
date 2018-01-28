require 'rails_helper'

RSpec.describe "schooltypes/show", type: :view do
  before(:each) do
    @schooltype = assign(:schooltype, Schooltype.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
