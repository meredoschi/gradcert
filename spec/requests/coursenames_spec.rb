require 'rails_helper'

RSpec.describe "Coursenames", :type => :request do
  describe "GET /coursenames" do
    it "works! (now write some real specs)" do
      get coursenames_path
      expect(response.status).to be(200)
    end
  end
end
