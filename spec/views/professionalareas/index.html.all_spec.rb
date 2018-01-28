require 'rails_helper'

RSpec.describe "professionalareas/index", type: :view do
  before(:each) do
    assign(:professionalareas, [
      Professionalarea.create!(
        :name => "Name",
        :previouscode => "Previouscode"
      ),
      Professionalarea.create!(
        :name => "Name",
        :previouscode => "Previouscode"
      )
    ])
  end

  it "renders a list of professionalareas" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Previouscode".to_s, :count => 2
  end
end
