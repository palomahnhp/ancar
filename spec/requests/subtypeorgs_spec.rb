require 'rails_helper'

RSpec.describe "Subtypeorgs", type: :request do
  describe "GET /subtypeorgs" do
    it "works! (now write some real specs)" do
      get subtypeorgs_path
      expect(response).to have_http_status(200)
    end
  end
end
