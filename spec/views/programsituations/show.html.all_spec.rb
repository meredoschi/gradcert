require 'rails_helper'

RSpec.describe "programsituations/show", :type => :view do
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
      :second_year_instructional_hours_practice => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
  end
end
