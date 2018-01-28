require 'rails_helper'

RSpec.describe "schoolterms/index", type: :view do
  before(:each) do
    assign(:schoolterms, [
      Schoolterm.create!(
        :duration => 1,
        :active => false,
        :pap => false,
        :medres => false
      ),
      Schoolterm.create!(
        :duration => 1,
        :active => false,
        :pap => false,
        :medres => false
      )
    ])
  end

  it "renders a list of schoolterms" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
