require 'rails_helper'

RSpec.describe "gifts/new", :type => :view do
  before(:each) do
    assign(:gift, Gift.new(
      :name => "MyString"
    ))
  end

  it "renders new gift form" do
    render

    assert_select "form[action=?][method=?]", gifts_path, "post" do

      assert_select "input#gift_name[name=?]", "gift[name]"
    end
  end
end
