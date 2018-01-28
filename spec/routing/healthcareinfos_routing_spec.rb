require "rails_helper"

RSpec.describe HealthcareinfosController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/healthcareinfos").to route_to("healthcareinfos#index")
    end

    it "routes to #new" do
      expect(:get => "/healthcareinfos/new").to route_to("healthcareinfos#new")
    end

    it "routes to #show" do
      expect(:get => "/healthcareinfos/1").to route_to("healthcareinfos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/healthcareinfos/1/edit").to route_to("healthcareinfos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/healthcareinfos").to route_to("healthcareinfos#create")
    end

    it "routes to #update" do
      expect(:put => "/healthcareinfos/1").to route_to("healthcareinfos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/healthcareinfos/1").to route_to("healthcareinfos#destroy", :id => "1")
    end

  end
end
