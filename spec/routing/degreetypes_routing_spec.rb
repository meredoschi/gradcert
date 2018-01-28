require "rails_helper"

RSpec.describe DegreetypesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/degreetypes").to route_to("degreetypes#index")
    end

    it "routes to #new" do
      expect(:get => "/degreetypes/new").to route_to("degreetypes#new")
    end

    it "routes to #show" do
      expect(:get => "/degreetypes/1").to route_to("degreetypes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/degreetypes/1/edit").to route_to("degreetypes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/degreetypes").to route_to("degreetypes#create")
    end

    it "routes to #update" do
      expect(:put => "/degreetypes/1").to route_to("degreetypes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/degreetypes/1").to route_to("degreetypes#destroy", :id => "1")
    end

  end
end
