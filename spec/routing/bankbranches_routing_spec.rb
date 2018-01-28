require "rails_helper"

RSpec.describe BankbranchesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/bankbranches").to route_to("bankbranches#index")
    end

    it "routes to #new" do
      expect(:get => "/bankbranches/new").to route_to("bankbranches#new")
    end

    it "routes to #show" do
      expect(:get => "/bankbranches/1").to route_to("bankbranches#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bankbranches/1/edit").to route_to("bankbranches#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/bankbranches").to route_to("bankbranches#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bankbranches/1").to route_to("bankbranches#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bankbranches/1").to route_to("bankbranches#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bankbranches/1").to route_to("bankbranches#destroy", :id => "1")
    end

  end
end
