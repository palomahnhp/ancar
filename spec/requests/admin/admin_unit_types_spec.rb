require 'rails_helper'

RSpec.describe "Admin::UnitTypes", type: :request do
  describe "GET /admin_unit_types" do
    it "works! (now write some real specs)" do
      get admin_unit_types_path
      expect(response).to have_http_status(200)
    end
  end
end
