require "rails_helper"

RSpec.describe MainProcessesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/main_processes").to route_to("main_processes#index")
    end

    it "routes to #new" do
      expect(:get => "/main_processes/new").to route_to("main_processes#new")
    end

    it "routes to #show" do
      expect(:get => "/main_processes/1").to route_to("main_processes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/main_processes/1/edit").to route_to("main_processes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/main_processes").to route_to("main_processes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/main_processes/1").to route_to("main_processes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/main_processes/1").to route_to("main_processes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/main_processes/1").to route_to("main_processes#destroy", :id => "1")
    end

  end
end
