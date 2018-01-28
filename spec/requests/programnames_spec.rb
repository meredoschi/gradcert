require 'rails_helper'

RSpec.describe "Programnames", :type => :request do
  describe "GET /programnames" do
    it "works! (now write some real specs)" do
      get programnames_path
      expect(response.status).to be(200)
    end
  end
end
