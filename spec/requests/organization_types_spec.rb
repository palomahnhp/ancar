require 'rails_helper'

RSpec.describe "OrganizationTypes", type: :request do
  describe "GET /organization_types" do
    it "works! (now write some real specs)" do
      get organization_types_path
      expect(response).to have_http_status(200)
    end
  end
end
