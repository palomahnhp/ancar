require "rails_helper"

RSpec.describe TypeOrganizationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/type_organizations").to route_to("type_organizations#index")
    end

    it "routes to #new" do
      expect(:get => "/type_organizations/new").to route_to("type_organizations#new")
    end

    it "routes to #show" do
      expect(:get => "/type_organizations/1").to route_to("type_organizations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/type_organizations/1/edit").to route_to("type_organizations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/type_organizations").to route_to("type_organizations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/type_organizations/1").to route_to("type_organizations#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/type_organizations/1").to route_to("type_organizations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/type_organizations/1").to route_to("type_organizations#destroy", :id => "1")
    end

  end
end
