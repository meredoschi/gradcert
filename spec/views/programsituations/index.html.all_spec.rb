require 'rails_helper'

RSpec.describe "programsituations/index", :type => :view do
  before(:each) do
    assign(:programsituations, [
      Programsituation.create!(
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
        :second_year_instructional_hours_practice => 2
      ),
      Programsituation.create!(
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
        :second_year_instructional_hours_practice => 2
      )
    ])
  end

  it "renders a list of programsituations" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
