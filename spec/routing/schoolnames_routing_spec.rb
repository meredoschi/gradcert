require "rails_helper"

RSpec.describe SchoolnamesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/schoolnames").to route_to("schoolnames#index")
    end

    it "routes to #new" do
      expect(:get => "/schoolnames/new").to route_to("schoolnames#new")
    end

    it "routes to #show" do
      expect(:get => "/schoolnames/1").to route_to("schoolnames#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/schoolnames/1/edit").to route_to("schoolnames#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/schoolnames").to route_to("schoolnames#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/schoolnames/1").to route_to("schoolnames#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/schoolnames/1").to route_to("schoolnames#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/schoolnames/1").to route_to("schoolnames#destroy", :id => "1")
    end

  end
end
