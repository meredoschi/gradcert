require "rails_helper"

RSpec.describe CharacteristicsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/characteristics").to route_to("characteristics#index")
    end

    it "routes to #new" do
      expect(:get => "/characteristics/new").to route_to("characteristics#new")
    end

    it "routes to #show" do
      expect(:get => "/characteristics/1").to route_to("characteristics#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/characteristics/1/edit").to route_to("characteristics#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/characteristics").to route_to("characteristics#create")
    end

    it "routes to #update" do
      expect(:put => "/characteristics/1").to route_to("characteristics#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/characteristics/1").to route_to("characteristics#destroy", :id => "1")
    end

  end
end
