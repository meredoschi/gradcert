require "rails_helper"

RSpec.describe SchooltypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/schooltypes").to route_to("schooltypes#index")
    end

    it "routes to #new" do
      expect(:get => "/schooltypes/new").to route_to("schooltypes#new")
    end

    it "routes to #show" do
      expect(:get => "/schooltypes/1").to route_to("schooltypes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/schooltypes/1/edit").to route_to("schooltypes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/schooltypes").to route_to("schooltypes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/schooltypes/1").to route_to("schooltypes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/schooltypes/1").to route_to("schooltypes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/schooltypes/1").to route_to("schooltypes#destroy", :id => "1")
    end

  end
end
