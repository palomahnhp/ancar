require "rails_helper"

RSpec.describe TypeorgsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/typeorgs").to route_to("typeorgs#index")
    end

    it "routes to #new" do
      expect(:get => "/typeorgs/new").to route_to("typeorgs#new")
    end

    it "routes to #show" do
      expect(:get => "/typeorgs/1").to route_to("typeorgs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/typeorgs/1/edit").to route_to("typeorgs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/typeorgs").to route_to("typeorgs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/typeorgs/1").to route_to("typeorgs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/typeorgs/1").to route_to("typeorgs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/typeorgs/1").to route_to("typeorgs#destroy", :id => "1")
    end

  end
end
