require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :leavetype_id => 1,
      :absence => false
    ))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input#event_leavetype_id[name=?]", "event[leavetype_id]"

      assert_select "input#event_absence[name=?]", "event[absence]"
    end
  end
end
