require "rails_helper"

RSpec.describe ProgramsituationsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/programsituations").to route_to("programsituations#index")
    end

    it "routes to #new" do
      expect(:get => "/programsituations/new").to route_to("programsituations#new")
    end

    it "routes to #show" do
      expect(:get => "/programsituations/1").to route_to("programsituations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/programsituations/1/edit").to route_to("programsituations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/programsituations").to route_to("programsituations#create")
    end

    it "routes to #update" do
      expect(:put => "/programsituations/1").to route_to("programsituations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/programsituations/1").to route_to("programsituations#destroy", :id => "1")
    end

  end
end
