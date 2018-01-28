require 'rails_helper'

RSpec.describe "schools/index", type: :view do
  before(:each) do
    assign(:schools, [
      School.create!(
        :name => "Name",
        :abbreviation => "Abbreviation",
        :ministrycode => 1,
        :academiccategory_id => 2,
        :public => false
      ),
      School.create!(
        :name => "Name",
        :abbreviation => "Abbreviation",
        :ministrycode => 1,
        :academiccategory_id => 2,
        :public => false
      )
    ])
  end

  it "renders a list of schools" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Abbreviation".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
