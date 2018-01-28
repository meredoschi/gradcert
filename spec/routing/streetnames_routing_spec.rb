require "rails_helper"

RSpec.describe StreetnamesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/streetnames").to route_to("streetnames#index")
    end

    it "routes to #new" do
      expect(:get => "/streetnames/new").to route_to("streetnames#new")
    end

    it "routes to #show" do
      expect(:get => "/streetnames/1").to route_to("streetnames#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/streetnames/1/edit").to route_to("streetnames#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/streetnames").to route_to("streetnames#create")
    end

    it "routes to #update" do
      expect(:put => "/streetnames/1").to route_to("streetnames#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/streetnames/1").to route_to("streetnames#destroy", :id => "1")
    end

  end
end
