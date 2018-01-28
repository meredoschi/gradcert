require 'rails_helper'

RSpec.describe "Degreetypes", :type => :request do
  describe "GET /degreetypes" do
    it "works! (now write some real specs)" do
      get degreetypes_path
      expect(response.status).to be(200)
    end
  end
end
