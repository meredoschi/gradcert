require 'rails_helper'

RSpec.describe "Placesavailables", type: :request do
  describe "GET /placesavailables" do
    it "works! (now write some real specs)" do
      get placesavailables_path
      expect(response).to have_http_status(200)
    end
  end
end
