require 'rails_helper'

RSpec.describe "Colleges", :type => :request do
  describe "GET /colleges" do
    it "works! (now write some real specs)" do
      get colleges_path
      expect(response.status).to be(200)
    end
  end
end
