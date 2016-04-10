require 'rails_helper'

RSpec.describe "Mainprocesses", type: :request do
  describe "GET /mainprocesses" do
    it "works! (now write some real specs)" do
      get mainprocesses_path
      expect(response).to have_http_status(200)
    end
  end
end
