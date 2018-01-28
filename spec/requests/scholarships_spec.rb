require 'rails_helper'

RSpec.describe "Scholarships", type: :request do
  describe "GET /scholarships" do
    it "works! (now write some real specs)" do
      get scholarships_path
      expect(response).to have_http_status(200)
    end
  end
end
