require "rails_helper"

RSpec.describe TaxationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/taxations").to route_to("taxations#index")
    end

    it "routes to #new" do
      expect(:get => "/taxations/new").to route_to("taxations#new")
    end

    it "routes to #show" do
      expect(:get => "/taxations/1").to route_to("taxations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/taxations/1/edit").to route_to("taxations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/taxations").to route_to("taxations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/taxations/1").to route_to("taxations#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/taxations/1").to route_to("taxations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/taxations/1").to route_to("taxations#destroy", :id => "1")
    end

  end
end
