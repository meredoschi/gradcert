require 'rails_helper'

RSpec.describe "makeupschedules/index", type: :view do
  before(:each) do
    assign(:makeupschedules, [
      Makeupschedule.create!(
        :registration_id => 1
      ),
      Makeupschedule.create!(
        :registration_id => 1
      )
    ])
  end

  it "renders a list of makeupschedules" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
