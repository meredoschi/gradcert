require 'rails_helper'

RSpec.describe "Programsituations", :type => :request do
  describe "GET /programsituations" do
    it "works! (now write some real specs)" do
      get programsituations_path
      expect(response.status).to be(200)
    end
  end
end
