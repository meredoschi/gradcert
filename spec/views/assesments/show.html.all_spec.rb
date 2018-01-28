require 'rails_helper'

RSpec.describe "assesments/show", :type => :view do
  before(:each) do
    @assesment = assign(:assesment, Assesment.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/Summary Of Program Goals/)
    expect(rendered).to match(/Program Nature Vocation/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9/)
    expect(rendered).to match(/10/)
  end
end
