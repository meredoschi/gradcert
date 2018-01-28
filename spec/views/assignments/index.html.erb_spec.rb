require 'rails_helper'

RSpec.describe "assignments/index", :type => :view do
  before(:each) do
    assign(:assignments, [
      Assignment.create!(
        :program_id => 1,
        :supervisor_id => 2,
        :main => false
      ),
      Assignment.create!(
        :program_id => 1,
        :supervisor_id => 2,
        :main => false
      )
    ])
  end

  it "renders a list of assignments" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
