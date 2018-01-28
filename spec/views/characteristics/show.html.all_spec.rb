require 'rails_helper'

RSpec.describe "characteristics/show", :type => :view do
  before(:each) do
    @characteristic = assign(:characteristic, Characteristic.create!(
      :institution_id => 1,
      :mission => "Mission",
      :corevalues => "Corevalues",
      :userprofile => "Userprofile",
      :stateregion_id => 2,
      :relationwithpublichealthcare => "Relationwithpublichealthcare",
      :publicfundinglevel => 1.5,
      :highlightareas => "Highlightareas"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Mission/)
    expect(rendered).to match(/Corevalues/)
    expect(rendered).to match(/Userprofile/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Relationwithpublichealthcare/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/Highlightareas/)
  end
end
