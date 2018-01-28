require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before(:each) do
    assign(:event, Event.new(
      :leavetype_id => 1,
      :absence => false
    ))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input#event_leavetype_id[name=?]", "event[leavetype_id]"

      assert_select "input#event_absence[name=?]", "event[absence]"
    end
  end
end
