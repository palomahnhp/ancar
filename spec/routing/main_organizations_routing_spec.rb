require "rails_helper"

RSpec.describe MainOrganizationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/main_organizations").to route_to("main_organizations#index")
    end

    it "routes to #new" do
      expect(:get => "/main_organizations/new").to route_to("main_organizations#new")
    end

    it "routes to #show" do
      expect(:get => "/main_organizations/1").to route_to("main_organizations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/main_organizations/1/edit").to route_to("main_organizations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/main_organizations").to route_to("main_organizations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/main_organizations/1").to route_to("main_organizations#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/main_organizations/1").to route_to("main_organizations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/main_organizations/1").to route_to("main_organizations#destroy", :id => "1")
    end

  end
end
