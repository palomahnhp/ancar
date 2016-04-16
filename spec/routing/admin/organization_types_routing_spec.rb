require "rails_helper"

RSpec.describe Admin::OrganizationTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/organization_types").to route_to("admin/organization_types#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/organization_types/new").to route_to("admin/organization_types#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/organization_types/1").to route_to("admin/organization_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/organization_types/1/edit").to route_to("admin/organization_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/organization_types").to route_to("admin/organization_types#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/organization_types/1").to route_to("admin/organization_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/organization_types/1").to route_to("admin/organization_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/organization_types/1").to route_to("admin/organization_types#destroy", :id => "1")
    end

  end
end
