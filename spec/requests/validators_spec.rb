require 'rails_helper'

RSpec.describe "Validators", type: :request do
  describe "GET /validators" do
    it "works! (now write some real specs)" do
      get validators_path
      expect(response).to have_http_status(200)
    end
  end
end
