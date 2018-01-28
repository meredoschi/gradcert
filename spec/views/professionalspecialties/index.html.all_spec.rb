require 'rails_helper'

RSpec.describe "professionalspecialties/index", type: :view do
  before(:each) do
    assign(:professionalspecialties, [
      Professionalspecialty.create!(
        :name => "Name",
        :fundapcode => "Fundapcode",
        :professionalarea_id => 1
      ),
      Professionalspecialty.create!(
        :name => "Name",
        :fundapcode => "Fundapcode",
        :professionalarea_id => 1
      )
    ])
  end

  it "renders a list of professionalspecialties" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Fundapcode".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
