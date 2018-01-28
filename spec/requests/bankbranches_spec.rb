require 'rails_helper'

RSpec.describe "Bankbranches", type: :request do
  describe "GET /bankbranches" do
    it "works! (now write some real specs)" do
      get bankbranches_path
      expect(response).to have_http_status(200)
    end
  end
end
