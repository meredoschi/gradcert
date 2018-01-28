require 'rails_helper'

RSpec.describe "streetnames/index", :type => :view do
  before(:each) do
    assign(:streetnames, [
      Streetname.create!(
        :nome => "Nome"
      ),
      Streetname.create!(
        :nome => "Nome"
      )
    ])
  end

  it "renders a list of streetnames" do
    render
    assert_select "tr>td", :text => "Nome".to_s, :count => 2
  end
end
