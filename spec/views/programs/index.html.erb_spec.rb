require 'rails_helper'

RSpec.describe "programs/index", :type => :view do
  before(:each) do
    assign(:programs, [
      Program.create!(
        :institution_id => 1,
        :programname_id => 2,
        :programnum => 3,
        :instprogramnum => "Instprogramnum",
        :duration => 4,
        :varchar => "Varchar"
      ),
      Program.create!(
        :institution_id => 1,
        :programname_id => 2,
        :programnum => 3,
        :instprogramnum => "Instprogramnum",
        :duration => 4,
        :varchar => "Varchar"
      )
    ])
  end

  it "renders a list of programs" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Instprogramnum".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Varchar".to_s, :count => 2
  end
end
