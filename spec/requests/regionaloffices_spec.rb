require 'rails_helper'

RSpec.describe "Regionaloffices", :type => :request do
  describe "GET /regionaloffices" do
    it "works! (now write some real specs)" do
      get regionaloffices_path
      expect(response.status).to be(200)
    end
  end
end
