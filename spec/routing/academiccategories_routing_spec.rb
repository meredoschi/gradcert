require "rails_helper"

RSpec.describe AcademiccategoriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/academiccategories").to route_to("academiccategories#index")
    end

    it "routes to #new" do
      expect(:get => "/academiccategories/new").to route_to("academiccategories#new")
    end

    it "routes to #show" do
      expect(:get => "/academiccategories/1").to route_to("academiccategories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/academiccategories/1/edit").to route_to("academiccategories#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/academiccategories").to route_to("academiccategories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/academiccategories/1").to route_to("academiccategories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/academiccategories/1").to route_to("academiccategories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/academiccategories/1").to route_to("academiccategories#destroy", :id => "1")
    end

  end
end
