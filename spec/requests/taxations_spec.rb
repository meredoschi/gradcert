require 'rails_helper'

RSpec.describe "Taxations", type: :request do
  describe "GET /taxations" do
    it "works! (now write some real specs)" do
      get taxations_path
      expect(response).to have_http_status(200)
    end
  end
end
