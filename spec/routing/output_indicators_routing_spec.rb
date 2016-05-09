require "rails_helper"

RSpec.describe OutputIndicatorsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/output_indicators").to route_to("output_indicators#index")
    end

    it "routes to #new" do
      expect(:get => "/output_indicators/new").to route_to("output_indicators#new")
    end

    it "routes to #show" do
      expect(:get => "/output_indicators/1").to route_to("output_indicators#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/output_indicators/1/edit").to route_to("output_indicators#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/output_indicators").to route_to("output_indicators#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/output_indicators/1").to route_to("output_indicators#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/output_indicators/1").to route_to("output_indicators#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/output_indicators/1").to route_to("output_indicators#destroy", :id => "1")
    end

  end
end
