require 'rails_helper'

RSpec.describe "supervisors/new", :type => :view do
  before(:each) do
    assign(:supervisor, Supervisor.new(
      :contact_id => 1,
      :institution_id => 1,
      :profession_id => 1,
      :highest_degree_held => "MyString",
      :lead => false,
      :alternate => false,
      :total_working_hours_week => 1,
      :teaching_hours_week => 1,
      :contract_type => "MyString"
    ))
  end

  it "renders new supervisor form" do
    render

    assert_select "form[action=?][method=?]", supervisors_path, "post" do

      assert_select "input#supervisor_contact_id[name=?]", "supervisor[contact_id]"

      assert_select "input#supervisor_institution_id[name=?]", "supervisor[institution_id]"

      assert_select "input#supervisor_profession_id[name=?]", "supervisor[profession_id]"

      assert_select "input#supervisor_highest_degree_held[name=?]", "supervisor[highest_degree_held]"

      assert_select "input#supervisor_lead[name=?]", "supervisor[lead]"

      assert_select "input#supervisor_alternate[name=?]", "supervisor[alternate]"

      assert_select "input#supervisor_total_working_hours_week[name=?]", "supervisor[total_working_hours_week]"

      assert_select "input#supervisor_teaching_hours_week[name=?]", "supervisor[teaching_hours_week]"

      assert_select "input#supervisor_contract_type[name=?]", "supervisor[contract_type]"
    end
  end
end
