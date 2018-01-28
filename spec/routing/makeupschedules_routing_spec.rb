require "rails_helper"

RSpec.describe MakeupschedulesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/makeupschedules").to route_to("makeupschedules#index")
    end

    it "routes to #new" do
      expect(:get => "/makeupschedules/new").to route_to("makeupschedules#new")
    end

    it "routes to #show" do
      expect(:get => "/makeupschedules/1").to route_to("makeupschedules#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/makeupschedules/1/edit").to route_to("makeupschedules#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/makeupschedules").to route_to("makeupschedules#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/makeupschedules/1").to route_to("makeupschedules#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/makeupschedules/1").to route_to("makeupschedules#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/makeupschedules/1").to route_to("makeupschedules#destroy", :id => "1")
    end

  end
end
