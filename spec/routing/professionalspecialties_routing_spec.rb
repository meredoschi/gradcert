require "rails_helper"

RSpec.describe ProfessionalspecialtiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/professionalspecialties").to route_to("professionalspecialties#index")
    end

    it "routes to #new" do
      expect(:get => "/professionalspecialties/new").to route_to("professionalspecialties#new")
    end

    it "routes to #show" do
      expect(:get => "/professionalspecialties/1").to route_to("professionalspecialties#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/professionalspecialties/1/edit").to route_to("professionalspecialties#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/professionalspecialties").to route_to("professionalspecialties#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/professionalspecialties/1").to route_to("professionalspecialties#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/professionalspecialties/1").to route_to("professionalspecialties#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/professionalspecialties/1").to route_to("professionalspecialties#destroy", :id => "1")
    end

  end
end
