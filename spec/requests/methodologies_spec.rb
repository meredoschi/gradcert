require 'rails_helper'

RSpec.describe "Methodologies", :type => :request do
  describe "GET /methodologies" do
    it "works! (now write some real specs)" do
      get methodologies_path
      expect(response.status).to be(200)
    end
  end
end
