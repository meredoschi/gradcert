require 'rails_helper'

RSpec.describe "Microregions", :type => :request do
  describe "GET /microregions" do
    it "works! (now write some real specs)" do
      get microregions_path
      expect(response.status).to be(200)
    end
  end
end
