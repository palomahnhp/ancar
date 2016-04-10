require "rails_helper"

RSpec.describe MainprocessesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/mainprocesses").to route_to("mainprocesses#index")
    end

    it "routes to #new" do
      expect(:get => "/mainprocesses/new").to route_to("mainprocesses#new")
    end

    it "routes to #show" do
      expect(:get => "/mainprocesses/1").to route_to("mainprocesses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/mainprocesses/1/edit").to route_to("mainprocesses#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/mainprocesses").to route_to("mainprocesses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/mainprocesses/1").to route_to("mainprocesses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/mainprocesses/1").to route_to("mainprocesses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/mainprocesses/1").to route_to("mainprocesses#destroy", :id => "1")
    end

  end
end
