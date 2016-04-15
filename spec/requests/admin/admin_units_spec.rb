require 'rails_helper'

RSpec.describe "Admin::Units", type: :request do
  describe "GET /admin_units" do
    it "works! (now write some real specs)" do
      get admin_units_path
      expect(response).to have_http_status(200)
    end
  end
end
