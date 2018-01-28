require 'rails_helper'

RSpec.describe "makeupschedules/show", type: :view do
  before(:each) do
    @makeupschedule = assign(:makeupschedule, Makeupschedule.create!(
      :registration_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
  end
end
