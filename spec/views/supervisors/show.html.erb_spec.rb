require 'rails_helper'

RSpec.describe "supervisors/show", :type => :view do
  before(:each) do
    @supervisor = assign(:supervisor, Supervisor.create!(
      :contact_id => 1,
      :institution_id => 2,
      :profession_id => 3,
      :highest_degree_held => "Highest Degree Held",
      :lead => false,
      :alternate => false,
      :total_working_hours_week => 4,
      :teaching_hours_week => 5,
      :contract_type => "Contract Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Highest Degree Held/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/Contract Type/)
  end
end
