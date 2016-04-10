require "rails_helper"

RSpec.describe ProcesosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/procesos").to route_to("procesos#index")
    end

    it "routes to #new" do
      expect(:get => "/procesos/new").to route_to("procesos#new")
    end

    it "routes to #show" do
      expect(:get => "/procesos/1").to route_to("procesos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/procesos/1/edit").to route_to("procesos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/procesos").to route_to("procesos#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/procesos/1").to route_to("procesos#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/procesos/1").to route_to("procesos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/procesos/1").to route_to("procesos#destroy", :id => "1")
    end

  end
end
