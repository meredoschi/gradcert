require "rails_helper"

RSpec.describe ProgramnamesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/programnames").to route_to("programnames#index")
    end

    it "routes to #new" do
      expect(:get => "/programnames/new").to route_to("programnames#new")
    end

    it "routes to #show" do
      expect(:get => "/programnames/1").to route_to("programnames#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/programnames/1/edit").to route_to("programnames#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/programnames").to route_to("programnames#create")
    end

    it "routes to #update" do
      expect(:put => "/programnames/1").to route_to("programnames#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/programnames/1").to route_to("programnames#destroy", :id => "1")
    end

  end
end
