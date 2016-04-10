require 'rails_helper'

RSpec.describe "Procesos", type: :request do
  describe "GET /procesos" do
    it "works! (now write some real specs)" do
      get procesos_path
      expect(response).to have_http_status(200)
    end
  end
end
