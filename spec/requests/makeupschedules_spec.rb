require 'rails_helper'

RSpec.describe "Makeupschedules", type: :request do
  describe "GET /makeupschedules" do
    it "works! (now write some real specs)" do
      get makeupschedules_path
      expect(response).to have_http_status(200)
    end
  end
end
