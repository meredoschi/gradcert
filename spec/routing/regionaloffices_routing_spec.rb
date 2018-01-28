require "rails_helper"

RSpec.describe RegionalofficesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/regionaloffices").to route_to("regionaloffices#index")
    end

    it "routes to #new" do
      expect(:get => "/regionaloffices/new").to route_to("regionaloffices#new")
    end

    it "routes to #show" do
      expect(:get => "/regionaloffices/1").to route_to("regionaloffices#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/regionaloffices/1/edit").to route_to("regionaloffices#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/regionaloffices").to route_to("regionaloffices#create")
    end

    it "routes to #update" do
      expect(:put => "/regionaloffices/1").to route_to("regionaloffices#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/regionaloffices/1").to route_to("regionaloffices#destroy", :id => "1")
    end

  end
end
