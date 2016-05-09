require 'rails_helper'

RSpec.describe "output_indicators/edit", type: :view do
  before(:each) do
    @output_indicator = assign(:output_indicator, OutputIndicator.create!())
  end

  it "renders the edit output_indicator form" do
    render

    assert_select "form[action=?][method=?]", output_indicator_path(@output_indicator), "post" do
    end
  end
end
