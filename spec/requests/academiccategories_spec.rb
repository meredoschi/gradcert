require 'rails_helper'

RSpec.describe "Academiccategories", type: :request do
  describe "GET /academiccategories" do
    it "works! (now write some real specs)" do
      get academiccategories_path
      expect(response).to have_http_status(200)
    end
  end
end
