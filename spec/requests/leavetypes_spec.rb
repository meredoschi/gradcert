require 'rails_helper'

RSpec.describe "Leavetypes", type: :request do
  describe "GET /leavetypes" do
    it "works! (now write some real specs)" do
      get leavetypes_path
      expect(response).to have_http_status(200)
    end
  end
end
