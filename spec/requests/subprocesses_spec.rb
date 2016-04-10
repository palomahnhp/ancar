require 'rails_helper'

RSpec.describe "Subprocesses", type: :request do
  describe "GET /subprocesses" do
    it "works! (now write some real specs)" do
      get subprocesses_path
      expect(response).to have_http_status(200)
    end
  end
end
