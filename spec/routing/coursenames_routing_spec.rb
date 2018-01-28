require "rails_helper"

RSpec.describe CoursenamesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/coursenames").to route_to("coursenames#index")
    end

    it "routes to #new" do
      expect(:get => "/coursenames/new").to route_to("coursenames#new")
    end

    it "routes to #show" do
      expect(:get => "/coursenames/1").to route_to("coursenames#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/coursenames/1/edit").to route_to("coursenames#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/coursenames").to route_to("coursenames#create")
    end

    it "routes to #update" do
      expect(:put => "/coursenames/1").to route_to("coursenames#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/coursenames/1").to route_to("coursenames#destroy", :id => "1")
    end

  end
end
