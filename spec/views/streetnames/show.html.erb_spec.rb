require 'rails_helper'

RSpec.describe "streetnames/show", :type => :view do
  before(:each) do
    @streetname = assign(:streetname, Streetname.create!(
      :nome => "Nome"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nome/)
  end
end
