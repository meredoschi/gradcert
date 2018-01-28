require "rails_helper"

RSpec.describe LeavetypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/leavetypes").to route_to("leavetypes#index")
    end

    it "routes to #new" do
      expect(:get => "/leavetypes/new").to route_to("leavetypes#new")
    end

    it "routes to #show" do
      expect(:get => "/leavetypes/1").to route_to("leavetypes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/leavetypes/1/edit").to route_to("leavetypes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/leavetypes").to route_to("leavetypes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/leavetypes/1").to route_to("leavetypes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/leavetypes/1").to route_to("leavetypes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/leavetypes/1").to route_to("leavetypes#destroy", :id => "1")
    end

  end
end
