require 'rails_helper'

RSpec.describe "academiccategories/index", type: :view do
  before(:each) do
    assign(:academiccategories, [
      Academiccategory.create!(
        :name => "Name"
      ),
      Academiccategory.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of academiccategories" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
