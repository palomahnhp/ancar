require "rails_helper"

RSpec.describe SubtypeorgsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/subtypeorgs").to route_to("subtypeorgs#index")
    end

    it "routes to #new" do
      expect(:get => "/subtypeorgs/new").to route_to("subtypeorgs#new")
    end

    it "routes to #show" do
      expect(:get => "/subtypeorgs/1").to route_to("subtypeorgs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/subtypeorgs/1/edit").to route_to("subtypeorgs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/subtypeorgs").to route_to("subtypeorgs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/subtypeorgs/1").to route_to("subtypeorgs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/subtypeorgs/1").to route_to("subtypeorgs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/subtypeorgs/1").to route_to("subtypeorgs#destroy", :id => "1")
    end

  end
end
