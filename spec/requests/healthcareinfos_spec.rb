require 'rails_helper'

RSpec.describe "Healthcareinfos", :type => :request do
  describe "GET /healthcareinfos" do
    it "works! (now write some real specs)" do
      get healthcareinfos_path
      expect(response.status).to be(200)
    end
  end
end
