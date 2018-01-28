require 'rails_helper'

RSpec.describe "programs/show", :type => :view do
  before(:each) do
    @program = assign(:program, Program.create!(
      :institution_id => 1,
      :programname_id => 2,
      :programnum => 3,
      :instprogramnum => "Instprogramnum",
      :duration => 4,
      :varchar => "Varchar"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Instprogramnum/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Varchar/)
  end
end
