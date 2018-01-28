require 'rails_helper'

RSpec.describe "Assessments", :type => :request do
  describe "GET /assessments" do
    it "works! (now write some real specs)" do
      get assessments_path
      expect(response.status).to be(200)
    end
  end
end