require "rails_helper"

RSpec.describe ProfessionalfamiliesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/professionalfamilies").to route_to("professionalfamilies#index")
    end

    it "routes to #new" do
      expect(:get => "/professionalfamilies/new").to route_to("professionalfamilies#new")
    end

    it "routes to #show" do
      expect(:get => "/professionalfamilies/1").to route_to("professionalfamilies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/professionalfamilies/1/edit").to route_to("professionalfamilies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/professionalfamilies").to route_to("professionalfamilies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/professionalfamilies/1").to route_to("professionalfamilies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/professionalfamilies/1").to route_to("professionalfamilies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/professionalfamilies/1").to route_to("professionalfamilies#destroy", :id => "1")
    end

  end
end
