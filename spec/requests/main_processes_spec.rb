require 'rails_helper'

RSpec.describe "MainProcesses", type: :request do
  describe "GET /main_processes" do
    it "works! (now write some real specs)" do
      get main_processes_path
      expect(response).to have_http_status(200)
    end
  end
end
