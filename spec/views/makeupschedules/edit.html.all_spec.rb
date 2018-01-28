require 'rails_helper'

RSpec.describe "makeupschedules/edit", type: :view do
  before(:each) do
    @makeupschedule = assign(:makeupschedule, Makeupschedule.create!(
      :registration_id => 1
    ))
  end

  it "renders the edit makeupschedule form" do
    render

    assert_select "form[action=?][method=?]", makeupschedule_path(@makeupschedule), "post" do

      assert_select "input#makeupschedule_registration_id[name=?]", "makeupschedule[registration_id]"
    end
  end
end
