require "rails_helper"

RSpec.describe ValidatorsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/validators").to route_to("validators#index")
    end

    it "routes to #new" do
      expect(:get => "/validators/new").to route_to("validators#new")
    end

    it "routes to #show" do
      expect(:get => "/validators/1").to route_to("validators#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/validators/1/edit").to route_to("validators#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/validators").to route_to("validators#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/validators/1").to route_to("validators#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/validators/1").to route_to("validators#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/validators/1").to route_to("validators#destroy", :id => "1")
    end

  end
end
