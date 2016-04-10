require "rails_helper"

RSpec.describe SubprocessesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/subprocesses").to route_to("subprocesses#index")
    end

    it "routes to #new" do
      expect(:get => "/subprocesses/new").to route_to("subprocesses#new")
    end

    it "routes to #show" do
      expect(:get => "/subprocesses/1").to route_to("subprocesses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/subprocesses/1/edit").to route_to("subprocesses#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/subprocesses").to route_to("subprocesses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/subprocesses/1").to route_to("subprocesses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/subprocesses/1").to route_to("subprocesses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/subprocesses/1").to route_to("subprocesses#destroy", :id => "1")
    end

  end
end
