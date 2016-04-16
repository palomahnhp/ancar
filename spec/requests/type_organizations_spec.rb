require 'rails_helper'

RSpec.describe "TypeOrganizations", type: :request do
  describe "GET /type_organizations" do
    it "works! (now write some real specs)" do
      get type_organizations_path
      expect(response).to have_http_status(200)
    end
  end
end
