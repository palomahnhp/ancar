require 'rails_helper'

RSpec.describe AssignedEmployeeController, type: :controller do

  describe "GET #justify" do
    it "returns http success" do
      get :justify
      expect(response).to have_http_status(:success)
    end
  end

end
