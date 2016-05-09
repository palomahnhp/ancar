require 'rails_helper'

RSpec.describe "OutputIndicators", type: :request do
  describe "GET /output_indicators" do
    it "works! (now write some real specs)" do
      get output_indicators_path
      expect(response).to have_http_status(200)
    end
  end
end
