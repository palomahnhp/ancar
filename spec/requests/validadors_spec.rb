require 'rails_helper'

RSpec.describe "Validadors", type: :request do
  describe "GET /validadors" do
    it "works! (now write some real specs)" do
      get validadors_path
      expect(response).to have_http_status(200)
    end
  end
end
