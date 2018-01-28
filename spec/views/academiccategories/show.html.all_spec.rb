require 'rails_helper'

RSpec.describe "academiccategories/show", type: :view do
  before(:each) do
    @academiccategory = assign(:academiccategory, Academiccategory.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
