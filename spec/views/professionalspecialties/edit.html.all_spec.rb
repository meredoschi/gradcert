require 'rails_helper'

RSpec.describe "professionalspecialties/edit", type: :view do
  before(:each) do
    @professionalspecialty = assign(:professionalspecialty, Professionalspecialty.create!(
      :name => "MyString",
      :fundapcode => "MyString",
      :professionalarea_id => 1
    ))
  end

  it "renders the edit professionalspecialty form" do
    render

    assert_select "form[action=?][method=?]", professionalspecialty_path(@professionalspecialty), "post" do

      assert_select "input#professionalspecialty_name[name=?]", "professionalspecialty[name]"

      assert_select "input#professionalspecialty_fundapcode[name=?]", "professionalspecialty[fundapcode]"

      assert_select "input#professionalspecialty_professionalarea_id[name=?]", "professionalspecialty[professionalarea_id]"
    end
  end
end
