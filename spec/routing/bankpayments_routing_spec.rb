require "rails_helper"

RSpec.describe BankpaymentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/bankpayments").to route_to("bankpayments#index")
    end

    it "routes to #new" do
      expect(:get => "/bankpayments/new").to route_to("bankpayments#new")
    end

    it "routes to #show" do
      expect(:get => "/bankpayments/1").to route_to("bankpayments#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bankpayments/1/edit").to route_to("bankpayments#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/bankpayments").to route_to("bankpayments#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bankpayments/1").to route_to("bankpayments#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bankpayments/1").to route_to("bankpayments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bankpayments/1").to route_to("bankpayments#destroy", :id => "1")
    end

  end
end
