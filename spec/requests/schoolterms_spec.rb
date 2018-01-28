require 'rails_helper'

RSpec.describe "Schoolterms", type: :request do
  describe "GET /schoolterms" do
    it "works! (now write some real specs)" do
      get schoolterms_path
      expect(response).to have_http_status(200)
    end
  end
end
