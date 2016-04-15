require 'rails_helper'

RSpec.describe "Typeorgs", type: :request do
  describe "GET /typeorgs" do
    it "works! (now write some real specs)" do
      get typeorgs_path
      expect(response).to have_http_status(200)
    end
  end
end
