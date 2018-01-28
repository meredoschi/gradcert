require 'rails_helper'

RSpec.describe "Researchcenters", :type => :request do
  describe "GET /researchcenters" do
    it "works! (now write some real specs)" do
      get researchcenters_path
      expect(response.status).to be(200)
    end
  end
end
