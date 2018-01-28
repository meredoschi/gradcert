require 'rails_helper'

RSpec.describe "Institutions", :type => :request do
  describe "GET /institutions" do
    it "works! (now write some real specs)" do
      get institutions_path
      expect(response.status).to be(200)
    end
  end
end
