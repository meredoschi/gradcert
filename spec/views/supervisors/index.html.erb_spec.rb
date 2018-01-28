require 'rails_helper'

RSpec.describe "supervisors/index", :type => :view do
  before(:each) do
    assign(:supervisors, [
      Supervisor.create!(
        :contact_id => 1,
        :institution_id => 2,
        :profession_id => 3,
        :highest_degree_held => "Highest Degree Held",
        :lead => false,
        :alternate => false,
        :total_working_hours_week => 4,
        :teaching_hours_week => 5,
        :contract_type => "Contract Type"
      ),
      Supervisor.create!(
        :contact_id => 1,
        :institution_id => 2,
        :profession_id => 3,
        :highest_degree_held => "Highest Degree Held",
        :lead => false,
        :alternate => false,
        :total_working_hours_week => 4,
        :teaching_hours_week => 5,
        :contract_type => "Contract Type"
      )
    ])
  end

  it "renders a list of supervisors" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Highest Degree Held".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "Contract Type".to_s, :count => 2
  end
end
