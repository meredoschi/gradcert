require "rails_helper"

RSpec.describe StateregionsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/stateregions").to route_to("stateregions#index")
    end

    it "routes to #new" do
      expect(:get => "/stateregions/new").to route_to("stateregions#new")
    end

    it "routes to #show" do
      expect(:get => "/stateregions/1").to route_to("stateregions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/stateregions/1/edit").to route_to("stateregions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/stateregions").to route_to("stateregions#create")
    end

    it "routes to #update" do
      expect(:put => "/stateregions/1").to route_to("stateregions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/stateregions/1").to route_to("stateregions#destroy", :id => "1")
    end

  end
end
