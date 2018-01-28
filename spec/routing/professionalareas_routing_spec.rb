require "rails_helper"

RSpec.describe ProfessionalareasController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/professionalareas").to route_to("professionalareas#index")
    end

    it "routes to #new" do
      expect(:get => "/professionalareas/new").to route_to("professionalareas#new")
    end

    it "routes to #show" do
      expect(:get => "/professionalareas/1").to route_to("professionalareas#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/professionalareas/1/edit").to route_to("professionalareas#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/professionalareas").to route_to("professionalareas#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/professionalareas/1").to route_to("professionalareas#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/professionalareas/1").to route_to("professionalareas#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/professionalareas/1").to route_to("professionalareas#destroy", :id => "1")
    end

  end
end
