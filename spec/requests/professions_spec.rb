require 'rails_helper'

RSpec.describe "Professions", :type => :request do
  describe "GET /professions" do
    it "works! (now write some real specs)" do
      get professions_path
      expect(response.status).to be(200)
    end
  end
end
