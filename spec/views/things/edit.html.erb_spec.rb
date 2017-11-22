require 'rails_helper'

RSpec.describe "things/edit", type: :view do
  before(:each) do
    @thing = assign(:thing, Thing.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit thing form" do
    render

    assert_select "form[action=?][method=?]", thing_path(@thing), "post" do

      assert_select "input#thing_name[name=?]", "thing[name]"
    end
  end
end
