require 'rails_helper'

RSpec.describe "professions/show", :type => :view do
  before(:each) do
    @profession = assign(:profession, Profession.create!(
      :name => "Name",
      :occupationcode => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
  end
end
