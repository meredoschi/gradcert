require 'rails_helper'

RSpec.describe "Stateregions", :type => :request do
  describe "GET /stateregions" do
    it "works! (now write some real specs)" do
      get stateregions_path
      expect(response.status).to be(200)
    end
  end
end
