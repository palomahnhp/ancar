require 'rails_helper'

RSpec.describe "Admin::OrganizationTypes", type: :request do
  describe "GET /admin_organization_types" do
    it "works! (now write some real specs)" do
      get admin_organization_types_path
      expect(response).to have_http_status(200)
    end
  end
end
