require 'rails_helper'

RSpec.describe "output_indicators/new", type: :view do
  before(:each) do
    assign(:output_indicator, OutputIndicator.new())
  end

  it "renders new output_indicator form" do
    render

    assert_select "form[action=?][method=?]", output_indicators_path, "post" do
    end
  end
end
