require 'rails_helper'

RSpec.describe "awards/show", :type => :view do
  before(:each) do
    @award = assign(:award, Award.create!(
      :name => "Name",
      :year => 1,
      :student_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
