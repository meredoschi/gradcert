require 'rails_helper'

RSpec.describe "Streetnames", :type => :request do
  describe "GET /streetnames" do
    it "works! (now write some real specs)" do
      get streetnames_path
      expect(response.status).to be(200)
    end
  end
end
