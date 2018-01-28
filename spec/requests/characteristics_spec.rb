require 'rails_helper'

RSpec.describe "Characteristics", :type => :request do
  describe "GET /characteristics" do
    it "works! (now write some real specs)" do
      get characteristics_path
      expect(response.status).to be(200)
    end
  end
end
