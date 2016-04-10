require "rails_helper"

RSpec.describe ValidadorsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/validadors").to route_to("validadors#index")
    end

    it "routes to #new" do
      expect(:get => "/validadors/new").to route_to("validadors#new")
    end

    it "routes to #show" do
      expect(:get => "/validadors/1").to route_to("validadors#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/validadors/1/edit").to route_to("validadors#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/validadors").to route_to("validadors#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/validadors/1").to route_to("validadors#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/validadors/1").to route_to("validadors#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/validadors/1").to route_to("validadors#destroy", :id => "1")
    end

  end
end
