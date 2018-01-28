require "rails_helper"

RSpec.describe InstitutiontypesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/institutiontypes").to route_to("institutiontypes#index")
    end

    it "routes to #new" do
      expect(:get => "/institutiontypes/new").to route_to("institutiontypes#new")
    end

    it "routes to #show" do
      expect(:get => "/institutiontypes/1").to route_to("institutiontypes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/institutiontypes/1/edit").to route_to("institutiontypes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/institutiontypes").to route_to("institutiontypes#create")
    end

    it "routes to #update" do
      expect(:put => "/institutiontypes/1").to route_to("institutiontypes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/institutiontypes/1").to route_to("institutiontypes#destroy", :id => "1")
    end

  end
end
