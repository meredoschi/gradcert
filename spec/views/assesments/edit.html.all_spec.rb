require 'rails_helper'

RSpec.describe "assesments/edit", :type => :view do
  before(:each) do
    @assesment = assign(:assesment, Assesment.create!(
      :contact_id => 1,
      :program_id => 1,
      :profession_id => 1,
      :duration_change_requested => false,
      :expected_duration => 1,
      :expected_first_year_grants => 1,
      :expected_second_year_grants => 1,
      :summary_of_program_goals => "MyString",
      :program_nature_vocation => "MyString",
      :first_year_theory_hours => 1,
      :first_year_practice_hours => 1,
      :second_year_theory_hours => 1,
      :second_year_practice_hours => 1
    ))
  end

  it "renders the edit assesment form" do
    render

    assert_select "form[action=?][method=?]", assesment_path(@assesment), "post" do

      assert_select "input#assesment_contact_id[name=?]", "assesment[contact_id]"

      assert_select "input#assesment_program_id[name=?]", "assesment[program_id]"

      assert_select "input#assesment_profession_id[name=?]", "assesment[profession_id]"

      assert_select "input#assesment_duration_change_requested[name=?]", "assesment[duration_change_requested]"

      assert_select "input#assesment_expected_duration[name=?]", "assesment[expected_duration]"

      assert_select "input#assesment_expected_first_year_grants[name=?]", "assesment[expected_first_year_grants]"

      assert_select "input#assesment_expected_second_year_grants[name=?]", "assesment[expected_second_year_grants]"

      assert_select "input#assesment_summary_of_program_goals[name=?]", "assesment[summary_of_program_goals]"

      assert_select "input#assesment_program_nature_vocation[name=?]", "assesment[program_nature_vocation]"

      assert_select "input#assesment_first_year_theory_hours[name=?]", "assesment[first_year_theory_hours]"

      assert_select "input#assesment_first_year_practice_hours[name=?]", "assesment[first_year_practice_hours]"

      assert_select "input#assesment_second_year_theory_hours[name=?]", "assesment[second_year_theory_hours]"

      assert_select "input#assesment_second_year_practice_hours[name=?]", "assesment[second_year_practice_hours]"
    end
  end
end
