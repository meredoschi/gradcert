require "rails_helper"

RSpec.describe ScholarshipsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/scholarships").to route_to("scholarships#index")
    end

    it "routes to #new" do
      expect(:get => "/scholarships/new").to route_to("scholarships#new")
    end

    it "routes to #show" do
      expect(:get => "/scholarships/1").to route_to("scholarships#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/scholarships/1/edit").to route_to("scholarships#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/scholarships").to route_to("scholarships#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/scholarships/1").to route_to("scholarships#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/scholarships/1").to route_to("scholarships#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/scholarships/1").to route_to("scholarships#destroy", :id => "1")
    end

  end
end
