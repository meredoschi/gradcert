require "rails_helper"

RSpec.describe ResearchcentersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/researchcenters").to route_to("researchcenters#index")
    end

    it "routes to #new" do
      expect(:get => "/researchcenters/new").to route_to("researchcenters#new")
    end

    it "routes to #show" do
      expect(:get => "/researchcenters/1").to route_to("researchcenters#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/researchcenters/1/edit").to route_to("researchcenters#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/researchcenters").to route_to("researchcenters#create")
    end

    it "routes to #update" do
      expect(:put => "/researchcenters/1").to route_to("researchcenters#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/researchcenters/1").to route_to("researchcenters#destroy", :id => "1")
    end

  end
end
