require 'rails_helper'

RSpec.describe "professionalspecialties/new", type: :view do
  before(:each) do
    assign(:professionalspecialty, Professionalspecialty.new(
      :name => "MyString",
      :fundapcode => "MyString",
      :professionalarea_id => 1
    ))
  end

  it "renders new professionalspecialty form" do
    render

    assert_select "form[action=?][method=?]", professionalspecialties_path, "post" do

      assert_select "input#professionalspecialty_name[name=?]", "professionalspecialty[name]"

      assert_select "input#professionalspecialty_fundapcode[name=?]", "professionalspecialty[fundapcode]"

      assert_select "input#professionalspecialty_professionalarea_id[name=?]", "professionalspecialty[professionalarea_id]"
    end
  end
end
