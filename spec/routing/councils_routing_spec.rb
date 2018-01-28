require "rails_helper"

RSpec.describe CouncilsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/councils").to route_to("councils#index")
    end

    it "routes to #new" do
      expect(:get => "/councils/new").to route_to("councils#new")
    end

    it "routes to #show" do
      expect(:get => "/councils/1").to route_to("councils#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/councils/1/edit").to route_to("councils#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/councils").to route_to("councils#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/councils/1").to route_to("councils#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/councils/1").to route_to("councils#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/councils/1").to route_to("councils#destroy", :id => "1")
    end

  end
end
