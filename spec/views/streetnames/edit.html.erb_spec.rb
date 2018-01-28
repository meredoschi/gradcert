require 'rails_helper'

RSpec.describe "streetnames/edit", :type => :view do
  before(:each) do
    @streetname = assign(:streetname, Streetname.create!(
      :nome => "MyString"
    ))
  end

  it "renders the edit streetname form" do
    render

    assert_select "form[action=?][method=?]", streetname_path(@streetname), "post" do

      assert_select "input#streetname_nome[name=?]", "streetname[nome]"
    end
  end
end
