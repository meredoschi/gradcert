require 'rails_helper'

RSpec.describe "programs/edit", :type => :view do
  before(:each) do
    @program = assign(:program, Program.create!(
      :institution_id => 1,
      :programname_id => 1,
      :programnum => 1,
      :instprogramnum => "MyString",
      :duration => 1,
      :varchar => "MyString"
    ))
  end

  it "renders the edit program form" do
    render

    assert_select "form[action=?][method=?]", program_path(@program), "post" do

      assert_select "input#program_institution_id[name=?]", "program[institution_id]"

      assert_select "input#program_programname_id[name=?]", "program[programname_id]"

      assert_select "input#program_programnum[name=?]", "program[programnum]"

      assert_select "input#program_instprogramnum[name=?]", "program[instprogramnum]"

      assert_select "input#program_duration[name=?]", "program[duration]"

      assert_select "input#program_varchar[name=?]", "program[varchar]"
    end
  end
end
