require 'rails_helper'

RSpec.describe "indicators/show", type: :view do
  before(:each) do
    @indicator = assign(:indicator, Indicator.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
