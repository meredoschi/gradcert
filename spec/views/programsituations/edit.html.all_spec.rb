require 'rails_helper'

RSpec.describe "programsituations/edit", :type => :view do
  before(:each) do
    @programsituation = assign(:programsituation, Programsituation.create!(
      :assesment_id => 1,
      :duration_change_requested => "",
      :expected_duration => "",
      :expected_first_year_grants => "",
      :expected_second_year_grants => "",
      :summary_of_program_goals => "",
      :program_nature => "",
      :first_year_instructional_hours_theory => "",
      :first_year_instructional_hours_practice => "",
      :second_year_instructional_hours_theory => "",
      :second_year_instructional_hours_practice => 1
    ))
  end

  it "renders the edit programsituation form" do
    render

    assert_select "form[action=?][method=?]", programsituation_path(@programsituation), "post" do

      assert_select "input#programsituation_assesment_id[name=?]", "programsituation[assesment_id]"

      assert_select "input#programsituation_duration_change_requested[name=?]", "programsituation[duration_change_requested]"

      assert_select "input#programsituation_expected_duration[name=?]", "programsituation[expected_duration]"

      assert_select "input#programsituation_expected_first_year_grants[name=?]", "programsituation[expected_first_year_grants]"

      assert_select "input#programsituation_expected_second_year_grants[name=?]", "programsituation[expected_second_year_grants]"

      assert_select "input#programsituation_summary_of_program_goals[name=?]", "programsituation[summary_of_program_goals]"

      assert_select "input#programsituation_program_nature[name=?]", "programsituation[program_nature]"

      assert_select "input#programsituation_first_year_instructional_hours_theory[name=?]", "programsituation[first_year_instructional_hours_theory]"

      assert_select "input#programsituation_first_year_instructional_hours_practice[name=?]", "programsituation[first_year_instructional_hours_practice]"

      assert_select "input#programsituation_second_year_instructional_hours_theory[name=?]", "programsituation[second_year_instructional_hours_theory]"

      assert_select "input#programsituation_second_year_instructional_hours_practice[name=?]", "programsituation[second_year_instructional_hours_practice]"
    end
  end
end
