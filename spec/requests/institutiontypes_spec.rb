require 'rails_helper'

RSpec.describe "Institutiontypes", :type => :request do
  describe "GET /institutiontypes" do
    it "works! (now write some real specs)" do
      get institutiontypes_path
      expect(response.status).to be(200)
    end
  end
end
