require 'rails_helper'

RSpec.describe "output_indicators/show", type: :view do
  before(:each) do
    @output_indicator = assign(:output_indicator, OutputIndicator.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
