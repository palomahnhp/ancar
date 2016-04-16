require 'rails_helper'

RSpec.describe "MainOrganizations", type: :request do
  describe "GET /main_organizations" do
    it "works! (now write some real specs)" do
      get main_organizations_path
      expect(response).to have_http_status(200)
    end
  end
end
