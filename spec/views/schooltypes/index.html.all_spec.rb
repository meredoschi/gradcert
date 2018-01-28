require 'rails_helper'

RSpec.describe "schooltypes/index", type: :view do
  before(:each) do
    assign(:schooltypes, [
      Schooltype.create!(
        :name => "Name"
      ),
      Schooltype.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of schooltypes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
