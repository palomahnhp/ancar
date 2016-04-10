require "rails_helper"

RSpec.describe SubprocesosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/subprocesos").to route_to("subprocesos#index")
    end

    it "routes to #new" do
      expect(:get => "/subprocesos/new").to route_to("subprocesos#new")
    end

    it "routes to #show" do
      expect(:get => "/subprocesos/1").to route_to("subprocesos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/subprocesos/1/edit").to route_to("subprocesos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/subprocesos").to route_to("subprocesos#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/subprocesos/1").to route_to("subprocesos#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/subprocesos/1").to route_to("subprocesos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/subprocesos/1").to route_to("subprocesos#destroy", :id => "1")
    end

  end
end
