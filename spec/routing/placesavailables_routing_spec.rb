require "rails_helper"

RSpec.describe PlacesavailablesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/placesavailables").to route_to("placesavailables#index")
    end

    it "routes to #new" do
      expect(:get => "/placesavailables/new").to route_to("placesavailables#new")
    end

    it "routes to #show" do
      expect(:get => "/placesavailables/1").to route_to("placesavailables#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/placesavailables/1/edit").to route_to("placesavailables#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/placesavailables").to route_to("placesavailables#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/placesavailables/1").to route_to("placesavailables#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/placesavailables/1").to route_to("placesavailables#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/placesavailables/1").to route_to("placesavailables#destroy", :id => "1")
    end

  end
end
