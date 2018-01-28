require 'rails_helper'

RSpec.describe "streetnames/new", :type => :view do
  before(:each) do
    assign(:streetname, Streetname.new(
      :nome => "MyString"
    ))
  end

  it "renders new streetname form" do
    render

    assert_select "form[action=?][method=?]", streetnames_path, "post" do

      assert_select "input#streetname_nome[name=?]", "streetname[nome]"
    end
  end
end
