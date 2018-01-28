require 'rails_helper'

RSpec.describe "Professionalspecialties", type: :request do
  describe "GET /professionalspecialties" do
    it "works! (now write some real specs)" do
      get professionalspecialties_path
      expect(response).to have_http_status(200)
    end
  end
end
