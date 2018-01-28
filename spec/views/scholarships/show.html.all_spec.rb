require 'rails_helper'

RSpec.describe "scholarships/show", type: :view do
  before(:each) do
    @scholarship = assign(:scholarship, Scholarship.create!(
      :amount => 1,
      :start => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
  end
end
