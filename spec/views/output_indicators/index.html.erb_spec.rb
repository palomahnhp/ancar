require 'rails_helper'

RSpec.describe "output_indicators/index", type: :view do
  before(:each) do
    assign(:output_indicators, [
      OutputIndicator.create!(),
      OutputIndicator.create!()
    ])
  end

  it "renders a list of output_indicators" do
    render
  end
end
