require 'rails_helper'

RSpec.describe "Professionalfamilies", type: :request do
  describe "GET /professionalfamilies" do
    it "works! (now write some real specs)" do
      get professionalfamilies_path
      expect(response).to have_http_status(200)
    end
  end
end
