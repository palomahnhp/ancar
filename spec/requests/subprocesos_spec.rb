require 'rails_helper'

RSpec.describe "Subprocesos", type: :request do
  describe "GET /subprocesos" do
    it "works! (now write some real specs)" do
      get subprocesos_path
      expect(response).to have_http_status(200)
    end
  end
end
