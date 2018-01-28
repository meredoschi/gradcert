require 'rails_helper'

RSpec.describe "assesments/index", :type => :view do
  before(:each) do
    assign(:assesments, [
      Assesment.create!(
        :contact_id => 1,
        :program_id => 2,
        :profession_id => 3,
        :duration_change_requested => false,
        :expected_duration => 4,
        :expected_first_year_grants => 5,
        :expected_second_year_grants => 6,
        :summary_of_program_goals => "Summary Of Program Goals",
        :program_nature_vocation => "Program Nature Vocation",
        :first_year_theory_hours => 7,
        :first_year_practice_hours => 8,
        :second_year_theory_hours => 9,
        :second_year_practice_hours => 10
      ),
      Assesment.create!(
        :contact_id => 1,
        :program_id => 2,
        :profession_id => 3,
        :duration_change_requested => false,
        :expected_duration => 4,
        :expected_first_year_grants => 5,
        :expected_second_year_grants => 6,
        :summary_of_program_goals => "Summary Of Program Goals",
        :program_nature_vocation => "Program Nature Vocation",
        :first_year_theory_hours => 7,
        :first_year_practice_hours => 8,
        :second_year_theory_hours => 9,
        :second_year_practice_hours => 10
      )
    ])
  end

  it "renders a list of assesments" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => "Summary Of Program Goals".to_s, :count => 2
    assert_select "tr>td", :text => "Program Nature Vocation".to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
  end
end
