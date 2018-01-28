require "rails_helper"

RSpec.describe SchooltermsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/schoolterms").to route_to("schoolterms#index")
    end

    it "routes to #new" do
      expect(:get => "/schoolterms/new").to route_to("schoolterms#new")
    end

    it "routes to #show" do
      expect(:get => "/schoolterms/1").to route_to("schoolterms#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/schoolterms/1/edit").to route_to("schoolterms#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/schoolterms").to route_to("schoolterms#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/schoolterms/1").to route_to("schoolterms#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/schoolterms/1").to route_to("schoolterms#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/schoolterms/1").to route_to("schoolterms#destroy", :id => "1")
    end

  end
end
