require 'rails_helper'

RSpec.describe "Professionalareas", type: :request do
  describe "GET /professionalareas" do
    it "works! (now write some real specs)" do
      get professionalareas_path
      expect(response).to have_http_status(200)
    end
  end
end
