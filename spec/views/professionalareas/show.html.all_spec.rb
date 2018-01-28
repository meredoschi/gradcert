require 'rails_helper'

RSpec.describe "professionalareas/show", type: :view do
  before(:each) do
    @professionalarea = assign(:professionalarea, Professionalarea.create!(
      :name => "Name",
      :previouscode => "Previouscode"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Previouscode/)
  end
end
