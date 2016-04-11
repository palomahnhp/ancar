require 'rails_helper'

RSpec.describe "indicators/index", type: :view do
  before(:each) do
    assign(:indicators, [
      Indicator.create!(),
      Indicator.create!()
    ])
  end

  it "renders a list of indicators" do
    render
  end
end
