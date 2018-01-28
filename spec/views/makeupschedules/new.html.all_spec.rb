require 'rails_helper'

RSpec.describe "makeupschedules/new", type: :view do
  before(:each) do
    assign(:makeupschedule, Makeupschedule.new(
      :registration_id => 1
    ))
  end

  it "renders new makeupschedule form" do
    render

    assert_select "form[action=?][method=?]", makeupschedules_path, "post" do

      assert_select "input#makeupschedule_registration_id[name=?]", "makeupschedule[registration_id]"
    end
  end
end
