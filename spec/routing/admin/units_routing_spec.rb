require "rails_helper"

RSpec.describe Admin::UnitsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/units").to route_to("admin/units#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/units/new").to route_to("admin/units#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/units/1").to route_to("admin/units#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/units/1/edit").to route_to("admin/units#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/units").to route_to("admin/units#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/units/1").to route_to("admin/units#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/units/1").to route_to("admin/units#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/units/1").to route_to("admin/units#destroy", :id => "1")
    end

  end
end
